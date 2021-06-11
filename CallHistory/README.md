# Call History Example

In this project, you can discover how to enable call history for direct call.

```swift
/************************
CallLogTableViewController.swift
************************/
var query: DirectCallLogListQuery?

let param = DirectCallLogListQuery.Params()
param.limit = 100
        
query = SendBirdCall.createDirectCallLogListQuery(with: param)
query?.next { [self] callLogs, error in
    // ...
}
```

## DirectCallLogListQuery
A user’s call history is available via a DirectCallLogListQuery instance.

## DirectCallLogListQuery.Params
Parameters for configuring DirectCallLogListQuery

## createDirectCallLogListQuery(with:)
Creates a Direct Call Log List Query from given params.

### Declaration
```swift
static func createDirectCallLogListQuery(with params: DirectCallLogListQuery.Params) -> DirectCallLogListQuery?
```

### Parameters
| Parameters | Description |
| --- | --- |
| params | DirectCallLogListQuery Params with options for creating query. |

### Returns
DirectCallLogListQuery: Returns optional query object. Returns nil if current user does not exit.

![Simulator Screen Shot - iPhone 12 - 2021-06-04 at 14 34 01](https://user-images.githubusercontent.com/53814741/120750862-08bc3e80-c542-11eb-875d-d2491821347d.png)
