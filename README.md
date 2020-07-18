# DecodeStrategy

![latest version](https://img.shields.io/cocoapods/v/DecodeStrategy)![license](https://img.shields.io/github/license/ohlulu/DecodeStrategy)![platform](https://img.shields.io/cocoapods/p/DecodeStrategy)

DecodeStrategy is convenient applying decode strategy if your backend uses weak type language.



## Features

- [x] Decode has default value, if decode failure

- [x] Decode array ignore, if decode failure

- [x] Decode array has default value, if decode failure

- [x] Universal decode with String, Int and Double type

    

## Installation

1.  Manually

    Add the Sources folder to your Xcode project.

2.  CocoaPods

    ```
    pod 'DecodeStrategy'
    ```

    

## Usage

### @DecodeHasDefault

1.  You can use `EmptyString`, `ZeroInt`, `ZeroDouble`

```swift
struct User: Decodable {
    @DecodeHasDefault<EmptyString>
    var name: String
}

let data = #"{ "name": null }"#.data(using: .utf8)!
let result = try JSONDecoder().decode(User.self, from: data)

print(result.name)
// ""
```

2.  Or custom your provider

```swift
struct User: Decodable {
    struct DefaultName: DecodeDefaultProvider {
        static var defaultValue = "Ohlulu"
    }
    @DecodeHasDefault<DefaultName>
    var name: String
}

let data = #"{ "name": null }"#.data(using: .utf8)!
let result = try JSONDecoder().decode(User.self, from: data)

print(result.name)
// "Ohlulu"
```



### @DecodeUniversal

```swift
struct Model: Decodable {
    @DecodeUniversal var intValue: Int
}

let data = #"{ "intValue": "100" }"#.data(using: .utf8)!
let model = try JSONDecoder().decode(Model.self, from: data)

print(model.intValue)
// 100
```

```swift
struct Model: Decodable {
    @DecodeUniversal var strValue: String
}

let data = #"{ "strValue": 100 }"#.data(using: .utf8)!
let model = try JSONDecoder().decode(Model.self, from: data)

print(model.strValue)
// "100"
```

>   [More example](https://github.com/ohlulu/DecodeStrategy/blob/master/DecodeStrategyTests/DecodeUniversal_Test.swift)



### @DecodeArrayIgnore

```swift
struct Model: Decodable {
    @DecodeArrayIgnore var arr: [String]
}

let data = #"{ "arr": ["1", 2, "3", null] }"#.data(using: .utf8)!
let model = try JSONDecoder().decode(Model.self, from: data)

print(model.arr)
// ["1", "3"]
```



### @DecodeArrayHasDefault

```swift
struct Model: Decodable {
    struct DefauleString: DecodeDefaultProvider {
        static var defaultValue = "-1"
    }
    @DecodeArrayHasDefault<DefauleString> var arr: [String]
}

let data = #"{ "arr": ["1", 2, "3", null] }"#.data(using: .utf8)!
let model = try JSONDecoder().decode(Model.self, from: data)

print(model.arr)
// ["1", "-1", "3", "-1"]
```



## License

DecodeStrategy is released under the MIT license. See LICENSE for details.