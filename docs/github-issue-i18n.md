# GitHub Issue: Internationalization (i18n) Support

**[中文版见文档末尾 / Chinese version at the bottom](#chinese)**

## Summary

Add full internationalization (i18n) support to Fizzy so that the application can be localized into multiple languages. This issue tracks the current state, remaining work, and implementation guidelines.

## Background

Fizzy currently uses Rails’ built-in I18n API with English as the default locale. Some views and flows already use `t()` for user-facing strings; many areas still contain hardcoded English text. This issue defines the i18n feature and outlines the path to complete localization.

## Current State

### Implemented

- **Rails I18n configuration** (`config/application.rb`):
  - `config.i18n.default_locale = :en`
  - Fallback to default locale via `config.i18n.fallbacks = true` (e.g. in production); `fallback_locales` is not set to avoid API mismatch with the I18n gem.
- **Locale files** under `config/locales/`:
  - `en.yml` – root English strings (e.g. `hello`)
  - `en/boards.yml` – board-related strings (edit, new, columns, column menu)
  - `en/cards.yml` – card container, display (stamp, meta), steps, watches
  - `en/shared.yml` – shared UI (back_to_label for back links, skip link, dialogs, colophon, welcome letter, columns)
  - `en/users.yml` – profile, email addresses, data export, theme, transfer, access tokens
  - `en/sessions.yml` – sign in, magic links, session menu
  - `en/signups.yml` – sign up, completion
  - `en/webhooks.yml` – index, new, edit, show, form actions
  - `en/notifications.yml` – settings, unsubscribe, push, email, system, install
  - `en/columns.yml` – choose, add card, no cards here, maximize/expand column
  - `en/tags.yml` – index (title, delete)
  - `en/reactions.yml` – new, reaction (add, delete)
  - `en/events.yml` – empty_days (no activity)
  - `en/account.yml` – join codes, exports, imports
  - `en/filters.yml` – toggle, added_by, closed_by, assigned_to, my shortcuts/settings/custom_views
  - `en/searches.yml` – close_search
  - `en/user_mailer.yml` – email_change_confirmation
  - `en/my.yml` – menus (shortcuts, settings, people, jump, custom_views, boards, accounts), access_tokens, pins
- **Views already using translations**: Card closure, board create/edit/columns/publication, card display (stamp, meta), card steps edit, column add/maximize, users (joins, edit, show, email, email confirmations invalid_token, data export), sessions (new, starts), signups, join_codes (new), webhooks (index, new, edit, show, form), tags, events empty_days, searches, reactions (new form aria), boards edit users, cards watches, user_mailer email_change_confirmation, notifications settings (system, install, browser platform-specific instructions), account (join_codes show/edit, imports show, settings export), CONTRIBUTING.md i18n section.

### Not Yet Done

- **Locale selection**: Implemented in Phase 3 — locale is persisted on `Identity`, set from params/session/identity in `SetLocale`, and a language selector is available on the profile (user edit) page.
- **Coverage**: Phase 2 follow-up completed; remaining hardcoded strings in users/joins, email_addresses/confirmations, join_codes, account (join_codes, imports, settings/export), boards publication, cards steps/display meta, reactions have been moved to locale files.
- **Additional locales**: Chinese (`zh`) has been added (Phase 4); locale files in `config/locales/zh/` and `config/locales/zh.yml`. Other languages (e.g. `es`, `ja`) can be added the same way.
- **Validation/error messages**: Model and validation messages may still be default Rails/English.
- **Test env**: `config.i18n.raise_on_missing_translations = true` is enabled in `config/environments/test.rb`.

## Proposed Scope

### Phase 1 – Foundation (current branch)

- [x] Extract card closure and related card container strings into `config/locales/en/cards.yml`
- [x] Use `t("cards.container.*")` in closure partials
- [x] Fix any misplaced keys (e.g. ensure `moves_to_not_now_suffix` lives under `cards.container`)
- [x] Add a short i18n section to CONTRIBUTING.md (where to add keys, naming conventions)

### Phase 2 – Full UI coverage

- [x] Audit all views, partials, and mailers for hardcoded user-facing strings
- [x] Move strings into appropriate locale files (`en/boards.yml`, `en/cards.yml`, `en/shared.yml`, and new files: users, sessions, signups, webhooks, notifications, columns, tags, reactions, events, account, filters, searches, user_mailer)
- [x] Ensure JavaScript/Stimulus user-visible strings are passed from the server where updated (e.g. bridge_title, turbo_confirm)
- [x] Use interpolation (`%{name}`, etc.) and `_html` suffix where HTML is required (e.g. users.data_exports.show.expired_html, welcome letter)

### Phase 3 – Locale selection (optional)

- [x] Add a way to set locale (e.g. user preference, account setting, or request/session)
- [x] Persist locale (e.g. on `User` or `Identity`) and set `I18n.locale` in a controller/middleware
- [x] Document how to add a new locale (copy `en/` to `xx/`, translate, add to `available_locales` if desired)

### Phase 4 – Additional languages (optional)

- [x] Add at least one non-English locale: **Chinese (`zh`)** — full locale files under `config/locales/zh/` and `config/locales/zh.yml`; `config.i18n.available_locales = [:en, :zh]`; locale selector shows "中文" / "Chinese".
- [ ] Ensure date/time and number formatting use `I18n.l` / `I18n.localize` where applicable (e.g. `local_datetime_tag` already helps with dates)

## Remaining tasks (Phase 2 follow-up)

These views/partials had hardcoded English strings; completed items are checked.

### Notifications

- [x] `notifications/unsubscribes/show.html.erb` – title, thanks text, "Notification Settings", "Back to Fizzy"
- [x] `notifications/unsubscribes/new.html.erb` – "Unsubscribe now"
- [x] `notifications/settings/show.html.erb` – page title, "Boards"
- [x] `notifications/settings/_system.html.erb` – platform-specific instructions (many platform/OS strings)
- [x] `notifications/settings/_push_notifications.html.erb` – ON/OFF, "Turn ON…", "Help me fix this", "Not receiving notifications?", when_not_working
- [x] `notifications/settings/_install.html.erb` – install instructions (platform-specific)
- [x] `notifications/settings/_email.html.erb` – "Email Notifications", "Email me about new notifications..."
- [x] `notifications/settings/_browser.html.erb` – "Turn on notifications for…", browser-specific steps
- [x] `notifications/notification/_header.html.erb` – "Card number"
- [x] `notifications/index/*` – "New for you", "Mark all as read", "Previously seen", showing_recent
- [x] `notifications/index.html.erb` – page title, "Notification settings", home
- [x] `notifications/_tray.html.erb` – "Notification Settings", "Settings", "See more/older items", "Clear all", "Notifications", toggle aria-label

### Filters

- [x] `filters/settings/_toggle.html.erb` – "Close/Expand/Collapse filter options"
- [x] `filters/settings/_terms.html.erb` – "Filter these cards…"
- [x] `filters/settings/_tags.html.erb` – "Tagged…", "Filter…"
- [x] `filters/settings/_sorted_by.html.erb` – "Sort by…"
- [x] `filters/settings/_manage.html.erb` – "Clear all"
- [x] `filters/settings/_indexed_by.html.erb` – "Status…", "Filter by…", "Filter by status…"
- [x] `filters/settings/_creators.html.erb` – "Added by…", "Filter…"
- [x] `filters/settings/_closers.html.erb` – "Closed by…", "Filter…"
- [x] `filters/settings/_assignees.html.erb` – "Assigned to…", "Filter…", "No one"
- [x] `filters/_settings.html.erb` – "Toggle filters"
- [x] `filters/_filter_toggle.html.erb` – "Delete custom view", "Save custom view"

### My menu & access tokens

- [x] `my/menus/_shortcuts.html.erb` – "Shortcuts", "Golden cards", "Stalled cards", "Cards closing soon", "Added today", "Done today"
- [x] `my/menus/_settings.html.erb` – "Settings", "Account Settings", "My Profile", "All notifications", "Notification Settings", "Sign out"
- [x] `my/menus/_people.html.erb` – "Invite people"
- [x] `my/menus/_jump.html.erb` – "Close menu", "Assigned to me", "Added by me", "Nothing matches that filter"
- [x] `my/menus/_custom_views.html.erb` – "Custom views", "Create a custom view"
- [x] `my/menus/_boards.html.erb` – "Add a board"
- [x] `my/menus/_accounts.html.erb` – "Accounts"
- [x] `my/access_tokens/*` – page titles, "Read", "Read + Write", "Copy access token", "Generate…", "Cancel and go back", "Description", "Permission", "Created", "Edit this token", revoke_confirm
- [x] `my/pins/*` – "Toggle pins stack", "Pinned", "Un-pin this card"

### Other (optional)

- [x] **Prompts** – `app/views/prompts/**` checked; content is user data (card titles, etc.), not fixed UI strings; no i18n needed.
- [x] **Testing**: Enable `config.i18n.raise_on_missing_translations = true` in `config/environments/test.rb`

### Phase 2 follow-up (additional views)

- [x] `users/joins/new.html.erb` – page title, full name placeholder, continue
- [x] `users/email_addresses/new.html.erb` – page title, my profile back link, new email placeholder, intro, continue
- [x] `users/email_addresses/confirmations/invalid_token.html.erb` – link expired, body, change my email, send us email
- [x] `join_codes/new.html.erb` – join page title (interpolation), email placeholder, continue
- [x] `cards/steps/edit.html.erb` – name placeholder, save/cancel changes, delete this step (screen reader)
- [x] `cards/display/public_preview/_meta.html.erb` – By, Updated, Assigned to
- [x] `cards/display/preview/_meta.html.erb` – Last updated, Assigned to (aria)
- [x] `boards/edit/_publication.html.erb` – public link, turn on/off, copy link, optional description, placeholder, save changes
- [x] `account/settings/_export.html.erb` – section title/intro, begin export, dialog title/body/footnote, start export, cancel
- [x] `account/join_codes/show.html.erb` – add people, account settings, share link, generate new code confirm, copy invite link, get QR code, scan QR, done, used count, change limit
- [x] `account/join_codes/edit.html.erb` – change usage limit, invite link, how many times, save changes, go back
- [x] `account/imports/show.html.erb` – import status heading, in progress, completed, go to account, failed, try again
- [x] `reactions/new.html.erb` – new reaction and add reaction aria labels

## Technical Notes

- **Where to add keys**: Prefer namespaced keys under `config/locales/en/`, e.g. `cards.container.edit`, `boards.new.page_title`. The full "Back to …" link text is built by `ApplicationHelper#back_link_to` using `shared.back_to_label` (e.g. "Back to %{label}") plus the page-specific label so the phrase is translatable in every locale.
- **Interpolation**: Use `t("key", name: value)` and `%{name}` in YAML.
- **HTML**: For HTML content use a key ending in `_html` and pass `_html: true` or use `.html_safe` only when the translation is trusted (e.g. `welcome_letter_intro_html` in `shared.yml`).
- **Testing**: Consider enabling `config.i18n.raise_on_missing_translations = true` in test to catch missing keys.
- **Production**: `config.i18n.fallbacks = true` is set so missing translations fall back to the default locale.

### How to add a new locale (Phase 3)

1. **Create locale files**: Copy the entire `config/locales/en/` directory to `config/locales/<locale>/` (e.g. `config/locales/es/` for Spanish). Translate all values; you can keep the same key structure and only change the string values.
2. **Register the locale**: In `config/application.rb`, add the new locale to `config.i18n.available_locales`, e.g. `config.i18n.available_locales = [:en, :es]`.
3. **Display name**: Add the language name for the locale selector in each locale file. In `config/locales/en/locales.yml` add under `locales.name` e.g. `es: "Spanish"`. In `config/locales/es/locales.yml` (when you create it) add `es: "Español"` and `en: "Inglés"` so the selector shows correct names in both languages.
4. **Run migration**: The locale column on `identities` is already in place; no extra migration is needed for new locales.
5. **Optional**: Set `config.i18n.default_locale` to the new locale for a locale-specific deployment, or leave as `:en` and rely on user/URL/session selection.

## Acceptance Criteria

- All user-facing strings in the areas targeted for the current phase are translated via `t()` and live in locale files.
- No new hardcoded English strings are introduced in those areas.
- Existing specs and system tests pass; new specs for critical i18n behavior are welcome (e.g. locale switching if Phase 3 is implemented).

## References

- [Rails I18n Guide](https://guides.rubyonrails.org/i18n.html)
- Current locale files: `config/locales/en/*.yml`
- Example usage: `app/views/cards/container/_closure.html.erb`, `app/views/cards/container/_closure_buttons.html.erb`

---

<a id="chinese"></a>

# 中文版：国际化 (i18n) 支持

## 概述

为 Fizzy 增加完整国际化 (i18n) 支持，使应用可被翻译为多种语言。本文档记录当前状态、剩余工作和实现说明。

## 背景

Fizzy 目前使用 Rails 内置的 I18n API，默认语言为英语。部分视图和流程已使用 `t()` 处理用户可见文案，仍有不少地方为硬编码英文。本文档定义 i18n 功能范围并说明完成本地化的路径。

## 当前状态

### 已完成

- **Rails I18n 配置**（`config/application.rb`）：
  - `config.i18n.default_locale = :en`
  - 通过 `config.i18n.fallbacks = true`（如在 production 中）回退到默认语言；未设置 `fallback_locales`，以避免与 I18n gem 的 API 不一致。
- **语言包**（位于 `config/locales/`）：
  - `en.yml` — 根级英文（如 `hello`）
  - `en/boards.yml` — 看板相关（编辑、新建、列、列菜单）
  - `en/cards.yml` — 卡片容器、展示（戳记、元信息）、步骤、关注
  - `en/shared.yml` — 共用 UI（跳过链接、对话框、版权、欢迎信、列）
  - `en/users.yml` — 个人资料、邮箱、数据导出、主题、转移、访问令牌
  - `en/sessions.yml` — 登录、魔法链接、会话菜单
  - `en/signups.yml` — 注册、完成
  - `en/webhooks.yml` — 列表、新建、编辑、详情、表单操作
  - `en/notifications.yml` — 设置、退订、推送、邮件、系统、安装
  - `en/columns.yml` — 选择、添加卡片、此处无卡片、最大化/展开列
  - `en/tags.yml` — 标签索引（标题、删除）
  - `en/reactions.yml` — 新建、反应（添加、删除）
  - `en/events.yml` — empty_days（无动态）
  - `en/account.yml` — 加入码、导出、导入
  - `en/filters.yml` — 切换、添加者、关闭者、指派给、我的快捷方式/设置/自定义视图
  - `en/searches.yml` — 关闭搜索
  - `en/user_mailer.yml` — 邮箱变更确认
  - `en/my.yml` — 菜单（快捷方式、设置、人员、跳转、自定义视图、看板、账户）、访问令牌、置顶
- **已使用翻译的视图**：卡片关闭、看板创建/编辑/列/公开、卡片展示（戳记、元信息）、卡片步骤编辑、列添加/最大化、用户（加入、编辑、详情、邮箱、邮箱确认 invalid_token、数据导出）、会话（登录、开始）、注册、join_codes（新建）、webhooks（列表、新建、编辑、详情、表单）、标签、事件 empty_days、搜索、反应（新建表单 aria）、看板编辑用户、卡片关注、user_mailer 邮箱变更确认、通知设置（系统、安装、浏览器平台说明）、账户（join_codes 详情/编辑、导入详情、设置导出）、CONTRIBUTING.md 的 i18n 小节。

### 未完成

- **语言选择**：已在第三阶段实现 — 语言保存在 `Identity` 上，由 params/session/identity 在 `SetLocale` 中设置，个人资料（用户编辑）页提供语言选择器。
- **覆盖范围**：第二阶段收尾已完成；用户/加入、邮箱/确认、join_codes、账户（join_codes、导入、设置/导出）、看板公开、卡片步骤/展示元信息、反应等处的硬编码已迁入语言包。
- **其他语言**：已添加中文（`zh`，第四阶段），语言包在 `config/locales/zh/` 与 `config/locales/zh.yml`。其他语言（如 `es`、`ja`）可按同样方式添加。
- **校验/错误信息**：模型与校验信息可能仍为 Rails 默认英文。
- **测试环境**：已在 `config/environments/test.rb` 中启用 `config.i18n.raise_on_missing_translations = true`。

## 建议范围

### 第一阶段 — 基础（当前分支）

- [x] 将卡片关闭及相关容器文案提取到 `config/locales/en/cards.yml`
- [x] 在关闭相关 partial 中使用 `t("cards.container.*")`
- [x] 修正错放的 key（如确保 `moves_to_not_now_suffix` 位于 `cards` 下）
- [x] 在 CONTRIBUTING.md 中增加简短 i18n 说明（key 放置位置、命名约定）

### 第二阶段 — 全 UI 覆盖

- [x] 审计所有视图、partial 和邮件中的用户可见硬编码文案
- [x] 将文案迁入对应语言包（en/boards、en/cards、en/shared 及新建的 users、sessions、signups、webhooks、notifications、columns、tags、reactions、events、account、filters、searches、user_mailer）
- [x] 确保 JavaScript/Stimulus 中的用户可见文案由服务端传入（如 bridge_title、turbo_confirm）
- [x] 使用插值（`%{name}` 等）及 `_html` 后缀处理需 HTML 的文案（如 users.data_exports.show.expired_html、欢迎信）

### 第三阶段 — 语言选择（可选）

- [x] 提供设置语言的方式（如用户偏好、账户设置或请求/会话）
- [x] 持久化语言（如存在 `User` 或 `Identity`），并在控制器/中间件中设置 `I18n.locale`
- [x] 文档说明如何添加新语言（复制 `en/` 为 `xx/`、翻译、按需加入 `available_locales`）

### 第四阶段 — 其他语言（可选）

- [x] 至少添加一种非英语语言：**中文（`zh`）** — 完整语言包位于 `config/locales/zh/` 与 `config/locales/zh.yml`；`config.i18n.available_locales = [:en, :zh]`；语言选择器显示「中文」/ "Chinese"。
- [ ] 确保日期/时间与数字格式在适用处使用 `I18n.l` / `I18n.localize`（如 `local_datetime_tag` 已用于日期）

## 技术说明

- **key 放置**：优先使用 `config/locales/en/` 下的命名空间 key，如 `cards.container.edit`、`boards.new.page_title`。返回链接的整句文案由 `ApplicationHelper#back_link_to` 通过 `shared.back_to_label`（如 "Back to %{label}"）与各页传入的 `label` 拼出，便于多语言下统一「返回 XXX」句式。
- **插值**：在 YAML 中使用 `t("key", name: value)` 和 `%{name}`。
- **HTML**：含 HTML 的文案使用以 `_html` 结尾的 key，并在受信任时传 `_html: true` 或使用 `.html_safe`（如 `shared.yml` 中的 `welcome_letter_intro_html`）。
- **测试**：建议在测试中启用 `config.i18n.raise_on_missing_translations = true` 以发现缺失 key。
- **生产**：已设置 `config.i18n.fallbacks = true`，缺失翻译会回退到默认语言。

### 如何添加新语言（第三阶段）

1. **创建语言包**：将 `config/locales/en/` 整目录复制为 `config/locales/<语言代码>/`（如西班牙语 `config/locales/es/`）。翻译所有值，可保持 key 结构不变，仅改字符串。
2. **注册语言**：在 `config/application.rb` 中将新语言加入 `config.i18n.available_locales`，如 `config.i18n.available_locales = [:en, :zh]`。
3. **显示名称**：在各语言包中为选择器添加语言名称。在 `config/locales/en/locales.yml` 的 `locales.name` 下添加如 `zh: "Chinese"`。在新建的 `config/locales/zh/locales.yml` 中添加 `zh: "中文"`、`en: "English"`，以便选择器在两种语言下都显示正确名称。
4. **迁移**：`identities` 上的 `locale` 列已存在，添加新语言无需额外迁移。
5. **可选**：若为某语言单独部署，可将 `config.i18n.default_locale` 设为该语言；否则保持 `:en`，由用户/URL/会话选择。

## 验收标准

- 当前阶段目标范围内的所有用户可见文案均通过 `t()` 使用语言包。
- 这些范围内不新增硬编码英文。
- 现有单元测试与系统测试通过；欢迎为关键 i18n 行为补充测试（如实现第三阶段时的语言切换）。

## 参考

- [Rails I18n 指南](https://guides.rubyonrails.org/i18n.html)
- 当前语言包：`config/locales/en/*.yml`
- 示例用法：`app/views/cards/container/_closure.html.erb`、`app/views/cards/container/_closure_buttons.html.erb`
