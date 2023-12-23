//
//  HapticManager.swift
//  Grates
//
//  Created by Out East on 15.12.2023.
//

import Foundation
import UIKit
import CoreHaptics
/// для акитивации различных вибраций и тактильных ощущений на устройстве
struct HapticManager {
    private static var engine: CHHapticEngine?
    private init() {
        
    }
    
    /// это функция подготовки класса к работе с haptic, которые были созданы пользоваетлем
    /// чтобы класс работал корректно, нужно запустить эту функцию в initial View Controller, чтобы
    /// класс настроил все, что ему нужно, до того, как пользователь сожет задействовать пользовательские haptic
    public static func prepare() {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else {
            return
        }
        do {
            HapticManager.engine = try CHHapticEngine()
            try HapticManager.engine?.start()
        } catch {
            print("ERROR - \(error.localizedDescription)")
        }
        
        HapticManager.engine?.stoppedHandler = { reason in
            print("ENGINE STOPPED - \(reason)")
            do {
                try HapticManager.engine?.start()
            } catch {
                print("FAILED TO RESTART - \(error.localizedDescription)")
            }
        }
        
        
        HapticManager.engine?.resetHandler = {
            print("Trying to reset")
            
            do {
                try HapticManager.engine?.start()
            } catch {
                print("FAILED TO RESTART - \(error.localizedDescription)")
            }
        }
    }
    
    // все вибрации должны проигрываться из главного потока
    /// обычно используется тогда, когда пользователь изменил какое-то значение в игре
    public static func selectionVibrate() {
        DispatchQueue.main.async {
            let selectionFeedbackGenerator = UISelectionFeedbackGenerator()
            selectionFeedbackGenerator.prepare()
            selectionFeedbackGenerator.selectionChanged()
        }
    }
    /// обычно используется тогда, когда нужно пометить оповещение для полльзователя
    public static func notificationVibrate(for type: UINotificationFeedbackGenerator.FeedbackType) {
        DispatchQueue.main.async {
            let notificationFeedbackGenerator = UINotificationFeedbackGenerator()
            notificationFeedbackGenerator.prepare()
            notificationFeedbackGenerator.notificationOccurred(type)
        }
    }
    /// обычно используется при физической симуляции(столкновении каких-либо объектов)
    /// или при нажатии на кнопку (я так буду делать)
    public static func collisionVibrate(with style: UIImpactFeedbackGenerator.FeedbackStyle,_ intensity: CGFloat) {
        DispatchQueue.main.async {
            let collisionFeedbackGenerator = UIImpactFeedbackGenerator(style: style)
            collisionFeedbackGenerator.prepare()
            
            collisionFeedbackGenerator.impactOccurred(intensity: intensity)
        }
        
    }
}
