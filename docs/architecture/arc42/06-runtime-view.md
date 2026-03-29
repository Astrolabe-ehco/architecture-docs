# 运行时视图 (Runtime View)

本节描绘了 Astrolabe 系统中最核心的两个动态运行时场景：高频数据上报与 AI 报告生成。

## 场景一：高频时间切片上报链路

移动终端产生的心跳记录、行为打点或体征数据，由应用统一提交并同步写入数据库，确保数据原子性与一致性。

```mermaid
sequenceDiagram
    participant App as Echo App (鸿蒙)
    participant Gateway as Main Backend (Go)
    participant DB as MySQL Database

    App->>Gateway: [HTTP POST] 上报时间切片与状态
    activate Gateway
    Gateway->>Gateway: JWT 鉴权与数据校验
    Gateway->>DB: [TCP] 执行同步 INSERT 落盘持久化
    Gateway-->>App: 200 OK
    deactivate Gateway
```

## 场景二：每日用户复盘与 AI 神谕生成

在每日结束时，用户在客户端手动撰写夜间复盘，后端会提取当日的所有量化打点数据，结合用户的复盘文本，构建带上下文的 Prompt 发送给大模型，生成专属的深度分析报告。

```mermaid
sequenceDiagram
    participant User as 用户
    participant App as 客户端 (Echo App / Web)
    participant Gateway as Main Backend (Go)
    participant DB as MySQL Database
    participant LLM as 外部大模型 API

    User->>App: 撰写每日总结与复盘提交
    App->>Gateway: [HTTP POST] 提交当日复盘文字
    activate Gateway
    Gateway->>DB: [TCP] 获取用户当日所有的行为切片与健康数据
    DB-->>Gateway: 返回结构化时序数据
    Gateway->>Gateway: 组装 Prompt (时序日志 + 用户复盘)
    Gateway->>LLM: [HTTPS] 调用生成回复流
    LLM-->>Gateway: 返回神谕解析 (基于打点与主观复盘)
    Gateway->>DB: 存储 AI 分析报告
    Gateway-->>App: 200 OK 报告并展示分析结果
    deactivate Gateway
```