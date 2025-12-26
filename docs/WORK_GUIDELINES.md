# 项目工作指引 (Project Work Guidelines)

本项目（New-API Desktop）涉及三个核心角色的协作：产品经理、运维架构、开发工程师。以下是各角色的详细职责分工。

## 1. 产品经理 (Product Manager - PM)

**核心职责**: 定义产品方向，优化用户体验，把控迭代进度。

*   **需求分析与规划**:
    *   根据市场竞品（如 LiteLLM, LM Studio）分析，制定产品路线图（Roadmap）。
    *   规划 MVP（Phase 1）及后续差异化功能（Phase 2，如托盘应用、自动发现 Ollama 等）。
    *   撰写和维护需求文档（如 `docs/product/NEXT_ITERATION_PLAN.md`）。
*   **用户体验 (UX/UI)**:
    *   确保桌面端的“单用户”体验流畅（例如：简化登录流程、自动创建 Root 账号）。
    *   设计配置向导和帮助指引。
*   **文档管理**:
    *   维护用户使用手册。
    *   管理版本发布说明（Release Notes）。

## 2. 运维架构 (Operations Architect - Ops/Arch)

**核心职责**: 搭建系统架构，保障构建稳定，优化系统性能与安全。

*   **系统架构设计**:
    *   设计 Wails 应用架构，整合 Go 后端与 React 前端。
    *   规划数据存储方案，确保 SQLite 数据库在各操作系统（Windows, macOS, Linux）的用户配置目录（User Config Dir）中正确存储。
    *   移除不适合桌面端的依赖（如 Redis），实施内存缓存策略。
*   **构建与部署**:
    *   维护构建脚本（Makefile, Wails Config），支持跨平台编译。
    *   管理项目依赖（Go Modules, NPM Packages）。
    *   设计自动更新机制（Auto-Update）。
*   **性能与安全**:
    *   优化应用启动速度和内存占用。
    *   确保本地 API 服务（Localhost）的安全性，防止未授权访问。

## 3. 开发工程师 (Development Engineer - Dev)

**核心职责**: 代码实现，功能开发，Bug 修复与测试。

*   **后端开发 (Golang)**:
    *   实现核心业务逻辑（Controller, Model）。
    *   将原有的 Gin 服务适配到 Wails 的生命周期中（后台协程运行）。
    *   实现 Wails Bindings 以处理原生系统交互（如打开目录、系统通知）。
*   **前端开发 (React)**:
    *   适配前端路由，将 `BrowserRouter` 替换为 `HashRouter`。
    *   配置 API 客户端，使其能够连接到本地后端端口（localhost:3000）。
    *   开发新的 UI 组件以适应桌面环境。
*   **测试与维护**:
    *   编写单元测试和集成测试。
    *   修复代码缺陷。
    *   遵循代码规范，配合代码审查。

---

**协作流程**:
1.  **PM** 提出需求并在 `docs/product/` 下更新文档。
2.  **Ops/Arch** 评估技术可行性并更新架构文档（`DESIGN.md`）。
3.  **Dev** 根据需求和架构进行编码实现。
4.  **Ops/Arch** 进行构建验证。
5.  **PM** 进行最终验收。
