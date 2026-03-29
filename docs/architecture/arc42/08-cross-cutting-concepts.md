# 交叉概念 (Cross-cutting Concepts)

本节涵盖了跨越多个组件的系统级概念和通用规则。

## 统一鉴权 (Authentication)
采用无状态的 **JWT (JSON Web Token)** 机制。
* Go 后端负责签发和校验 Token。
* 鸿蒙端与 Vue 前端在请求 Header 中携带 `Authorization: Bearer <token>`。
* 所有的 API 交互只有在成功完成 JWT 校验之后才会放行对底层数据的操作或外部大语言模型接口的调用。

## API 设计规范
系统交互统一采用 **RESTful API** 架构风格：
* 请求响应格式统一为 `application/json`。
* 统一的数据返回包装：`{ "code": 0, "msg": "success", "data": {...} }`。