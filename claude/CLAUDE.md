## Structure

Documents are stored in docs

## GIT
Never make a git commit with Claude as a co-author

## Code Intelligence — LSP Only

For any code navigation task, use **LSP exclusively**. Do NOT use Grep, Glob, or Read as substitutes for LSP operations.
| Task | LSP operation |
|------|---------------|
| Find where a symbol is defined | `goToDefinition` |
| Find all usages of a symbol | `findReferences` |
| Locate a class/function/variable | `workspaceSymbol` |
| List symbols in a file | `documentSymbol` |
| Get type/signature info | `hover` |
| Find implementations | `goToImplementation` |
| Trace callers/callees | `incomingCalls` / `outgoingCalls` |

**Before renaming or changing a signature**, always run `findReferences` first.

Grep, Glob, and Read are only permitted for:
- Searching **comments, strings, or config values** (not symbol names)
- Reading a file whose **full content** is needed
- Pattern searches where no LSP operation applies

If LSP returns no results, fall back and explain why LSP was insufficient.

After writing or editing code, check LSP diagnostics before
moving on. Fix any type errors or missing imports immediately.

@RTK.md
