# commandbox-githooks

## Manage your git hooks with CommandBox

### Installation

Install this package and set up your project to use it:

```bash
box install commandbox-githooks
cd my-git-project
box githooks install
```

Add your scripts to a `githooks` key in the `box.json`:

```json
{
  "githooks": {
    "preCommit": "testbox run",
    "preCheckout": [
      "install",
      "!npm install",
      "!gulp"
    ]
  }
}
```
