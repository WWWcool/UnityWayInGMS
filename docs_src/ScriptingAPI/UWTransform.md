# UWTransform

<span class="badge badge-secondary">constructor</span>

## Description
Position, rotation and scale of an object.

## Arguments
| Name | Type | Description |
| ---- | ---- | ----------- |
| _parent | `UWTransform` |  |
| _obj | `object` | Instance of an object if we want transform control it |

## Returns
`UWTransform` created transform

## Methods
| Name | Description |
| ---- | ----------- |
| [DetachChildren](UWTransform.DetachChildren.html) | Unparents all children. |
| [GetChild](UWTransform.GetChild.html) | return a transform child by index. |
| [GetInfo](UWTransform.GetInfo.html) | Get info string specific for this component |
| [GetRoot](UWTransform.GetRoot.html) | return the topmost transform in the hierarchy. |
| [InverseTransformDirection](UWTransform.InverseTransformDirection.html) | Transforms a direction from world space to local space. |
| [InverseTransformScale](UWTransform.InverseTransformScale.html) | Transforms scale from world space to local space. |
| [InverseTransformVector](UWTransform.InverseTransformVector.html) | Transforms vector from world space to local space. |
| [IsChildOf](UWTransform.IsChildOf.html) | Is this transform a child of parent? |
| [LookAt](UWTransform.LookAt.html) | Rotates the transform so the forward vector points at target's current position. |
| [Rotate](UWTransform.Rotate.html) | Rotates the object around by the number of degrees defined by the given angle. |
| [SetInstance](UWTransform.SetInstance.html) | Set the instance of the transform. |
| [SetLocalPositionAndAngleAndScale](UWTransform.SetLocalPositionAndAngleAndScale.html) | Sets the local space position, angle and scale of the Transform component. |
| [SetParent](UWTransform.SetParent.html) | Set the parent of the transform. |
| [SetPositionAndAngleAndScale](UWTransform.SetPositionAndAngleAndScale.html) | Sets the world space position, angle and scale of the Transform component. |
| [TransformDirection](UWTransform.TransformDirection.html) | Transforms direction from local space to world space. |
| [TransformScale](UWTransform.TransformScale.html) | Transforms scale from local space to world space. |
| [TransformVector](UWTransform.TransformVector.html) | Transforms vector from local space to world space. |
| [Translate](UWTransform.Translate.html) | Moves the transform in the direction and distance of translation. |