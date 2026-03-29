# 部署视图 (Deployment View)

Astrolabe 的服务端采用容器化部署（Docker/Docker Compose），以保证开发、测试与生产环境的高度一致性。

## 物理节点拓扑

```mermaid
flowchart TB
    subgraph 用户终端
        App[鸿蒙手机/手表 Echo]
        Web[浏览器 Dashboard]
    end

    subgraph 云服务器 (Linux / Docker)
        Nginx[Nginx 反向代理 / 443]
        
        subgraph 业务网络 (echo-net)
            GoBackend[Main Backend:8080]
        end
        
        subgraph 数据网络 (db-net)
            MySQL[(MySQL:3306)]
        end
    end
    
    LLM((外部大模型 API))

    App -- HTTPS --> Nginx
    Web -- HTTPS --> Nginx
    Nginx -- 路由 /api --> GoBackend
    
    GoBackend -- TCP --> MySQL
    GoBackend -- HTTPS --> LLM