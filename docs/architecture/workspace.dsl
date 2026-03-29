workspace "Astrolabe" "An AI-driven Quantified Self & Behavior Analysis Ecosystem." {

    !docs arc42 

    model {
        user = person "Astrolabe User" "渴望量化自我、记录时间切片并获取生活节奏洞察的用户。"

        llmApi = softwareSystem "Cloud LLM Provider" "外部大语言模型 API，用于生成神谕报告。" "External"
        
        natServer = softwareSystem "NAT Traversal Proxy" "内网穿透公网节点（FRP 等），负责将公网流量隧道转发至物理宿舍主机。" "External"

        astrolabe = softwareSystem "Astrolabe Ecosystem" "时间记录与 AI 行为分析系统" {
            
            echoApp = container "Echo (Mobile Client)" "数据入口总汇：负责番茄钟、任务标记，并汇总手表端健康数据统一上报。" "HarmonyOS / ArkTS" "Mobile App"
            
            # 鸿蒙手表端容器与外部硬件
            echoWatch = container "Echo Watch Client (Wearable)" "无感采集心率、睡眠、步数以及系统性的运动锻炼数据。" "HarmonyOS / Wearable" "Wearable App"
            smartScale = container "Smart Scale (IoT Device)" "华为智能体脂秤，每两天一次获取体重与体脂等身体指标。" "Hardware" "Device"
            
            dashboard = container "Dashboard (Frontend)" "展示时序行为流、睡眠/健身量化图表及 AI 神谕报告。" "Vue 3 / TypeScript" "Web Browser"
            
            mainBackend = container "Main Backend (单体后端 - 局域网物理机)" "部署在内网主机，通过代理接收穿透数据流，处理业务与 AI 请求。" "Go / Gin" "Backend"
            
            mysqlDb = container "Relational Database" "部署在本地主机的持久化关联网络存储。" "MySQL" "Database"

            # 角色与系统交互
            user -> echoApp "使用手机记录任务、时间与撰写每日复盘"
            user -> echoWatch "佩戴手表自动同步健康与运动锻炼数据"
            user -> smartScale "定期称重测量体重与体脂"
            user -> dashboard "查看数据大屏，补充复盘与查看分析报告"

            # 内部与外部交互连线

            # 硬件与手机的数据流转
            echoWatch -> echoApp "本地同步心率、睡眠及运动锻炼数据 (分布式软总线/Health Kit)"
            smartScale -> echoApp "本地同步体重及体脂指标数据 (蓝牙/Health Kit)"

            # 数据上报经过内网穿透
            echoApp -> natServer "上报行为日志、各类生理/运动数据与复盘文本 (外部域名 HTTPS)"
            dashboard -> natServer "提交复盘、拉取数据与视图 (外部域名 HTTPS)"
            
            # 内网穿透流量路由到内网后端
            natServer -> mainBackend "TCP 隧道透明转发 (反向代理/流量打通)"
            
            # 后端基础操作
            mainBackend -> mysqlDb "本地局域网直接落盘与持久化读取 (TCP/SQL)"
            
            # 云端 AI 请求
            mainBackend -> llmApi "发送 Prompt (混合时序客观数据与用户主观复盘) 并接收分析结果 (JSON/HTTPS)"
        }
    }

    views {
        systemContext astrolabe "SystemContext" {
            include *
            autoLayout lr
            description "Astrolabe 的系统上下文图 (Level 1)"
        }

        container astrolabe "Container" {
            include *
            autoLayout lr
            description "Astrolabe 的容器架构图 (Level 2)"
        }

        theme default
        
        styles {
            element "Database" {
                shape Cylinder
            }
            element "External" {
                background #999999
                color #ffffff
            }
            element "Mobile App" {
                shape MobileDevicePortrait
            }
            element "Web Browser" {
                shape WebBrowser
            }
            element "Backend" {
                background #438dd5
                color #ffffff
            }
            # 手表端与智能硬件的样式
            element "Wearable App" {
                shape MobileDevicePortrait
                background #438dd5
                color #ffffff
            }
            element "Device" {
                shape Component
                background #888888
                color #ffffff
            }
        }
    }
}