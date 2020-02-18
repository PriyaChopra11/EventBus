# Event Bus

**EventBus** is a coco framework which provides an publish/subscribe event flow. User can use this library to achieve publish/subscribe event flow with minimum lines of code.

## Requirements

- iOS 13.0+ 
- Xcode 11.0+
- Swift 5+

## Features
- [x] Thread Safe
- [x] Duplicacy of subscribers not allowed
- [x] Custom data can be sent with every Event.
- [x] Subscribers can be un-registered.

## Subscriber

A `subscriber` can simply conforms the `Subscriber` Protocol and implement it's requirements. User can provide the list events that it is interested in through `eventsToSubscribe` variable. 

Subscriber also must implement  `didReceiveEvent` whenever any publish will publish the event you are interested  in you will be notfied via this method.

## Usage

### Register Subscriber

User can register subscriber by calling `add` function on `EventBus`. 
Usage shown below :-

```swift

add(subscriber: self)

```

### UnRegister Subscriber

When a subscriber is no longer interested in listening events It can be removed as a listener from event bus by calling `remove`
function as shown below.

```swift

remove(subscriber: self) 

```
### PublishEvent

When an event is published subscriber is notified via `publish(for event: String, with data: [String: Any]?)`.
In this function you will get the event for which the function has been fired and custom data corresponding to the event.

