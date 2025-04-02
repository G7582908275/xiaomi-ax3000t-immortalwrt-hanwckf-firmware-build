def read_config_file(file_path):
    """读取配置文件并返回配置字典"""
    config_dict = {}
    with open(file_path, 'r', encoding='utf-8') as f:
        for line in f:
            line = line.strip()
            # 跳过注释和空行
            if line.startswith('#') or not line:
                continue
            if '=' in line:
                key, value = line.split('=', 1)
                config_dict[key.strip()] = value.strip()
    return config_dict

def compare_configs(config1_path, config2_path):
    """比较两个配置文件的差异"""
    # 读取两个配置文件
    config1 = read_config_file(config1_path)
    config2 = read_config_file(config2_path)

    # 获取所有配置项的键
    all_keys = set(config1.keys()) | set(config2.keys())
    
    # 初始化比较结果
    only_in_config1 = []
    only_in_config2 = []
    different_values = []
    
    # 比较配置项
    for key in sorted(all_keys):
        if key not in config2:
            only_in_config1.append(f"{key}={config1[key]}")
        elif key not in config1:
            only_in_config2.append(f"{key}={config2[key]}")
        elif config1[key] != config2[key]:
            different_values.append(f"{key}: {config1_path}={config1[key]}, {config2_path}={config2[key]}")
    
    # 打印结果
    print(f"配置文件比较结果：\n")
    
    print(f"仅在 {config1_path} 中存在的配置项 ({len(only_in_config1)}):")
    for item in only_in_config1:
        print(f"  {item}")
    print()
    
    print(f"仅在 {config2_path} 中存在的配置项 ({len(only_in_config2)}):")
    for item in only_in_config2:
        print(f"  {item}")
    print()
    
    print(f"配置值不同的项目 ({len(different_values)}):")
    for item in different_values:
        print(f"  {item}")
    print()
    
    # 打印统计信息
    total_configs1 = len(config1)
    total_configs2 = len(config2)
    print(f"统计信息：")
    print(f"{config1_path} 总配置项数: {total_configs1}")
    print(f"{config2_path} 总配置项数: {total_configs2}")
    print(f"相同配置项数: {total_configs1 - len(only_in_config1) - len(different_values)}")

def main():
    # 指定要比较的两个配置文件路径
    config1_path = ".config"
    config2_path = "ax3000t_3.config"
    
    try:
        compare_configs(config1_path, config2_path)
    except FileNotFoundError as e:
        print(f"错误：找不到配置文件 - {e}")
    except Exception as e:
        print(f"发生错误：{e}")

if __name__ == "__main__":
    main()