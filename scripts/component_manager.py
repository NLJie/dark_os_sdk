import os
import yaml
import subprocess
from pathlib import Path

def load_config(config_path):
    """加载YAML配置文件"""
    with open(config_path, 'r') as file:
        config = yaml.safe_load(file)
    return config.get('components', [])

def clone_or_update_repo(repo_url, destination, version):
    """克隆或更新仓库到指定版本"""
    destination_path = Path(destination)
    
    # 如果目录已存在，则执行拉取和检出
    if destination_path.exists():
        print(f"Updating repository in {destination}")
        try:
            # 进入目录
            subprocess.run(['git', '-C', destination, 'fetch'], check=True)
            # 检出指定版本
            subprocess.run(['git', '-C', destination, 'checkout', version], check=True)
            # 拉取最新更改
            subprocess.run(['git', '-C', destination, 'pull', 'origin', version], check=True)
            print(f"Successfully updated {repo_url} to {version}")
        except subprocess.CalledProcessError as e:
            print(f"Error updating repository {repo_url}: {e}")
            return False
    else:
        # 克隆仓库
        print(f"Cloning repository {repo_url} to {destination}")
        try:
            # 先克隆到临时目录，然后移动以避免权限问题
            temp_dir = str(destination_path.parent / f".temp_{destination_path.name}")
            subprocess.run(['git', 'clone', repo_url, temp_dir], check=True)
            
            # 移动到最终位置并检出指定版本
            Path(temp_dir).rename(destination)
            subprocess.run(['git', '-C', destination, 'checkout', version], check=True)
            print(f"Successfully cloned {repo_url} to {destination}")
        except subprocess.CalledProcessError as e:
            print(f"Error cloning repository {repo_url}: {e}")
            # 清理临时目录
            if Path(temp_dir).exists():
                Path(temp_dir).rmtree_p()
            return False
    
    return True

def main():
    # 获取当前脚本所在的目录
    script_dir = Path(__file__).parent.resolve()  # 使用 resolve() 获取绝对路径
    print(f"Script directory: {script_dir}")  # 打印脚本所在目录

    # 配置文件路径（在 script_dir 的上一层目录中）
    config_file = script_dir.parent / 'components.yml'
    print(f"Config file path: {config_file}")  # 打印配置文件路径

    # 检查配置文件是否存在
    if not config_file.exists():
        print(f"Error: Configuration file {config_file} not found.")
        return
    
    # 加载配置
    components = load_config(config_file)
    
    if not components:
        print("No components configured in the YAML file.")
        return
    
    # 确保components目录存在（在 script_dir 的上一层目录中）
    components_dir = script_dir.parent / 'components'
    components_dir.mkdir(exist_ok=True)
    
    # 处理每个组件
    for component in components:
        name = component.get('name')
        repo = component.get('repo')
        version = component.get('version', 'main')  # 默认为main分支
        destination = components_dir / name  # 直接使用 components 目录下的子目录
        
        if not all([name, repo]):
            print(f"Skipping invalid component entry: {component}")
            continue
        
        print(f"\nProcessing component: {name}")
        print(f"Repository: {repo}")
        print(f"Version: {version}")
        print(f"Destination: {destination}")
        
        success = clone_or_update_repo(repo, destination, version)
        
        if not success:
            print(f"Failed to process component: {name}")
            return

if __name__ == "__main__":
    main()