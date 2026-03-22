# Development Rules

通用开发规范，适用于所有项目。

## Code Quality

1. 模块化、可维护性、内联性是工程最基本的要求
2. 函数编写要节约清晰，一行 docstring 说明用途
3. 函数参数过多时，考虑定义 args 变量，采用 args.xxx 进行参数传递
4. 单行代码长度超过 150 进行一次换行
5. 代码逻辑不超过 400 行，超出则拆分

## Testing

- `if __name__ == "__main__"` + `python -m xxx.xxx` 是最佳测试方案
- 模块脚本不是工具脚本，不需要暴露参数

## Project Structure

- 项目代码统一放到项目同名文件夹模块目录下
- 根目录仅存放工程文件（docker-compose.yml、pyproject.toml、README.md 等）
- 配置统一使用 xxx_config.py 管理
- 可复用模块放到 utils，不要放到业务模块

## Error Handling

- 不要写兜底方案代码，兜底的是异常，不是方案
- 实现最新方案，异常要报错出来

## Encoding

- Windows 下文件操作使用 utf-8 编码
