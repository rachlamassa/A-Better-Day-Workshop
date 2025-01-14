//
//  RemindersView.swift
//  A Better Day Workshop
//
//  Created by Rachael LaMassa on 1/8/25.
//

import SwiftUI
import SwiftData
import UserNotifications

struct RemindersView: View {
    
    @AppStorage("ReminderTime") private var reminderTime: Double = Date().timeIntervalSince1970
    
    @AppStorage("RemindersOn") private var isRemindersOn = false
    @State private var selectedDate = Date().addingTimeInterval(86400)
    @State private var isSettingsDialogueShowing = false
    
    // computer property: gets calculated when accessed
    var formattedTime: String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: selectedDate)
    }
    
    var body: some View {
        VStack (spacing: 20) {
            Text("Reminders")
                .font(.largeTitle)
                .bold()
                .frame(maxWidth: .infinity, alignment: .leading)
            
            
            Text("Premind yourself to do something uplifting everyday.")
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Toggle(isOn: $isRemindersOn) {
                Text("Toggle Reminders:")
            }
            
            if isRemindersOn {
                HStack {
                    Text("What time?")
                    Spacer()
                    DatePicker("", selection: $selectedDate, displayedComponents: .hourAndMinute)
                }
                
                //tool tip saying when reminders are set for
                VStack (alignment: .leading, spacing: 10) {
                    Text(Image(systemName: "bell.and.waves.left.and.right"))
                    Text("You'll recieve a friendly reminder at \(formattedTime) on selected days to make your day better.")
                }
                .foregroundStyle(.blue)
                .padding()
                .background {
                    RoundedRectangle(cornerRadius: 10)
                        .strokeBorder(Color.blue, lineWidth: 1)
                        .background(Color("light-blue"))
                        .cornerRadius(10)
                }
                
            }
            else {
                // tool tip to turn reminders on
                ToolTipView(text: "Turn on reminders above to remind yourself to make each day better.")
            }
            
            Spacer()
            Image("reminders")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(maxWidth: 300)
            Spacer()
            
            
        }
        .padding(.trailing, 2)
        .onAppear(perform: {
            selectedDate = Date(timeIntervalSince1970: reminderTime)
        })
        .onChange(of: isRemindersOn) { oldValue, newValue in
            // check for permissions to send notifications
            let notificationCenter = UNUserNotificationCenter.current()
            
            notificationCenter.getNotificationSettings { settings in
                switch settings.authorizationStatus {
                case .notDetermined:
                    print("Notification permission has not been asked yet.")
                    // request it
                    requestNotificationPermission()
                case .denied:
                    print("Notifications are denied.")
                    isRemindersOn = false
                    // show a dialog saying that we can't send notifications and have a button to send the user to Settings
                    isSettingsDialogueShowing = true
                case .authorized:
                    print("Notifications are authorized")
                    // schedule notifications
                    scheduleNotifications()
                default:
                    break
                }
            }
        }
        .onChange(of: selectedDate) { oldValue, newValue in
            let notificationCenter = UNUserNotificationCenter.current()
            // unschedule all currently scheduled reminders
            notificationCenter.removeAllPendingNotificationRequests()
            // schedule new reminders
            scheduleNotifications()
            // save new time
            reminderTime = selectedDate.timeIntervalSince1970
        }
        .alert(isPresented: $isSettingsDialogueShowing) {
            Alert(title: Text("Notifications Disabled"), message: Text("Reminders won't be sent unless Notifications are allowed. Please allow them in Settings"), primaryButton: .default(Text("Go to Settings"), action: {
                // go to settings
                goToSettings()
            }), secondaryButton: .cancel())
        }
    }
    
    func goToSettings() {
        if let appSettings = URL(string: UIApplication.openSettingsURLString) {
            if UIApplication.shared.canOpenURL(appSettings) {
                UIApplication.shared.open(appSettings, options: [:], completionHandler: nil)
            }
        }
    }
    
    func requestNotificationPermission() {
        let notificationCenter = UNUserNotificationCenter.current()
        
        notificationCenter.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if granted {
                print("Permission granted.")
                // schedule notifications
                scheduleNotifications()
            }
            else {
                print("Permission denied.")
                isRemindersOn = false
                // show a dialog saying that we can't send notifications and have a button to send the user to Settings
                isSettingsDialogueShowing = true
            }
            
            if let error = error {
                print("Error requesting permission: \(error.localizedDescription)")
            }
        }
    }
    
    func scheduleNotifications() {
        let notificationCenter = UNUserNotificationCenter.current()
        
        // Define notification content
        let content = UNMutableNotificationContent()
        content.title = "A Better Day"
        content.body = "Don't forget to do something for yourself today!"
        content.sound = .default
        
        // Set up the daily trigger time (e.g., 8:00 AM)
        var dateComponents = DateComponents()
        dateComponents.hour = Calendar.autoupdatingCurrent.component(.hour, from: selectedDate)
        dateComponents.minute = Calendar.autoupdatingCurrent.component(.minute, from: selectedDate)
        
        // Create the calendar trigger
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        
        // Create the notification request
        let identifier = "dailyNotification"
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        
        // Add the notification request
        notificationCenter.add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error.localizedDescription)")
            } else {
                print("Daily notification scheduled")
            }
        }
    }
    
}

#Preview {
    RemindersView()
}
