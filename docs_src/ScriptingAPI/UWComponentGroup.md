# UWComponentGroup

<span class="badge badge-secondary">constructor</span>

## Description
Group components by some feature

## Arguments
| Name | Type | Description |
| ---- | ---- | ----------- |
| _type | `string` | index in object groups |
| _check_func | `script` | function that check if component suitable for group |
| _exec_func | `script` | function that do some work for group |

## Returns
`UWComponentGroup` created component group

## Methods
| Name | Description |
| ---- | ----------- |
| [Execute](UWComponentGroup.Execute.html) | Execute all component in group |
| [RemoveComponent](UWComponentGroup.RemoveComponent.html) | Remove component from group |
| [TryAddComponent](UWComponentGroup.TryAddComponent.html) | Add component to group if it pass check |