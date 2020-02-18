//
//  EventBus.swift
//  EventBus
//
//  Created by Priya Chopra on 2/2/2020.
//  Copyright © 2020 Priya Chopra. All rights reserved.
//

import UIKit

protocol Subscriber {
    /*
    Array of events for which subscriber would be interested
    to receive an event.
    **/
    var eventsToSubscribe: [String] { get }
    /**
        This method would be invoked when an event for which the subscriber is
        registered has been fired.

        - Parameter event: event which has been fired.
        - Parameter data:  Custom data corresponding to the event.
     
        */
    func didReceivedEvent(for event: String, with data: [String: Any]?)
}

class Weak: Equatable {
  
    weak var value: AnyObject?
    
    init(value: AnyObject) {
        self.value = value
    }
    
    static func == (lhs: Weak, rhs: Weak) -> Bool {
        lhs.value === rhs.value
      }
}

final class EventBus {
    /// its a dictionary contains topic as key and subscriber as it value of type Weak
    private var listeners = [String: [Weak]]()
    /// shared instance of Event bus class
    static let shared = EventBus.init()
    
    let syncQueue = DispatchQueue.init(label: "event bus")
    /**
        This function register/add subscriber for topics that want to get notified
     -  Parameter subscriber: Object that wants to be register
     */
    func add(subscriber: Subscriber) {
        let weakSubscriber = Weak.init(value: subscriber as AnyObject)
        let eventsToSubscribe = subscriber.eventsToSubscribe
        self.syncQueue.async {
            for event in eventsToSubscribe {
                if let existingSubscriber = self.listeners[event] {
                    guard !existingSubscriber.contains(weakSubscriber) else {
                        return
                    }
                    self.listeners[event, default: []].append(weakSubscriber)
                } else {
                    self.listeners[event] = [weakSubscriber]
                }
            }
        }
    }
    
    /**
         This function unregister/remove subscriber from list of listeners
        - Parameter subscriber: Object that wants to be removed
     */
    func remove(subscriber: Subscriber) {
        let eventsToSubscribe = subscriber.eventsToSubscribe
        self.syncQueue.async {
            for event in eventsToSubscribe {
                self.listeners.removeValue(forKey: event)
            }
        }
    }
    
    /**
     This function is to publish event to the registerd subscribers
     - Parameter event: topic for which subscribers wants to be notified
     - Parameter data:  Additional info that has to publish with topic
     */
    func publish(for event: String, with data: [String: Any]?) {
        self.syncQueue.async {
            if let existingSubscribers = self.listeners[event] {
                for weakSubscriber in existingSubscribers {
                    let subscriber = weakSubscriber.value as! Subscriber
                    subscriber.didReceivedEvent(for: event, with: data)
                }
            }
        }
    }
}


