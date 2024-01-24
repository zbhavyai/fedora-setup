# Eclipse

Eclipse IDE, a flagship project by the Eclipse Foundation, stands as a versatile and extensible integrated development environment primarily tailored for Java. The Eclipse Foundation, a stalwart in open-source communities, hosts impactful projects like Jakarta EE, ensuring the evolution of enterprise Java standards. Adoptium provides reliable OpenJDK-based binaries, Eclipse MicroProfile tackles microservices challenges, and Eclipse GlassFish serves as a Jakarta EE-compatible application server, collectively exemplifying the foundation's commitment to advancing collaborative and innovative solutions in the software development landscape.

## IDE Settings

### Indentation using spaces

1. Open Window -> Preferences -> General -> Editors -> Text Editors
2. Select `Insert spaces for tabs`

### LF line endings

1. Open Window -> Preferences -> General -> Workspace
2. Select `Other: Unix` under "New text file line delimiter"

### Tab switching

1. Open Window -> Preferences -> General -> Keys
2. Filter for "tab"
3. Use `Copy command` to copy the commands `Next Tab` and `Previous Tab`
4. Add `Ctrl+Tab` binding for `Next Tab`
5. Add `Ctrl+Shift+Tab` binding for `Previous Tab`

### Highlight code changes wrt Git

1. Open Window -> Preferences -> General -> Editors -> Text Editors -> Quick Diff
2. Select `Enable quick diff`
3. Choose `A Git Revision` in `Use this reference source`
4. Then go to Window -> Preferences -> General -> Editors -> Text Editors -> Accessibility
5. Select `Use characters to show changes in vertical ruler`

### Autoformat code on save

1. Open Window -> Preferences -> Java -> Editor -> Save Actions
2. Select `Perform the selected actions on save`
3. Select `Format source code` and `Format all lines`
4. Select `Additional actions` and configure...
5. Make sure below is displayed

   ```
   Add 'this' qualifier to unqualified field accesses
   Add 'this' qualifier to unqualified method accesses
   Convert control statement bodies to block
   Add missing '@Override' annotations
   Add missing '@Override' annotations to implementations of interface methods
   Add missing '@Deprecated' annotations
   Remove unnecessary casts
   Remove trailing white spaces on all lines
   Correct indentation
   ```

### Change the font

1. Open Window -> Preferences -> General -> Appearance -> Colors and Fonts
2. Expand `Basic`.
3. Edit the font of `Text Font` and `Text Editor Block Selection Font` to `Monospace 11`

### Update the JDK

Eclipse comes with a bundled JDK. To update it to the system-wide JDK installation:

1. Open Window -> Preferences -> Java -> Installed JREs
2. Click `Add` -> Standard VM
3. Fill in the details and make it the default by selecting the checkbox

## Some IDE shortcuts

| Key combo          | Function                                             |
| ------------------ | ---------------------------------------------------- |
| `Ctrl + 1`         | Show quickfix menu                                   |
| `F3`               | Jump to the implementation of the method             |
| `Ctrl + Alt + H`   | View call hierarchy of the method                    |
| `F4`               | View class hierarchy of the highlighted class        |
| `Ctrl + O`         | Class outline to navigate between methods and fields |
| `Ctrl + Shift + R` | Find and open any file in the workspace by name      |
| `Ctrl + Alt + Z`   | Surrond code with try-catch, or loops                |
| `Ctrl + Shift + O` | Add missing imports, organize existing imports       |
| `Alt + Shift + R`  | Refactor variable                                    |
| `Alt + Left Arrow` | Re-open closed tab                                   |
| `Ctrl + Shift + F` | Auto format file or highlighted code                 |
| `Ctrl + F11`       | Run the program                                      |
| `Ctrl + Shift + L` | List all shortcuts                                   |
