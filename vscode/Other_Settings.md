## Cycle Tabs in visible order

1. Press Ctrl+Shift+P
2. Type Preferences: Open Keyboard Shortcuts (JSON)
3. Add the below lines

```json
[
  {
    "key": "ctrl+tab",
    "command": "workbench.action.nextEditor"
  },

  {
    "key": "ctrl+shift+tab",
    "command": "workbench.action.previousEditor"
  }
]
```
