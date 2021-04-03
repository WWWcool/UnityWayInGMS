# UWDependency

<span class="badge badge-secondary">constructor</span>

## Description
Dependency represents uw components connections to other components or libs.

## Arguments
| Name | Type | Description |
| ---- | ---- | ----------- |
| _name | `string` |  |
| _defined | `bool` |  |
| _version | `number` |  |
| _min_version | `number` |  |
| _deps | `array(UWDependency)` |  |

## Returns
`UWDependency` created dependency

## Methods
| Name | Description |
| ---- | ----------- |
| [CheckDependencies](UWDependency.CheckDependencies.html) | Check self defined and if ok check self deps defined |