//
//  SetWorkingHoursView.swift
//  GitSpace
//
//  Created by 최한호 on 2023/02/09.
//

import SwiftUI

struct SetWorkingHoursView: View {
    
    @AppStorage("isWorkingHours") var isWorkingHours: Bool = false
    @AppStorage("isWorkingHoursCustom") var isWorkingHoursCustom: Bool = false
    
    @AppStorage("WorkingHoursFrom") var workingHoursFrom: String = "09:00"
    @AppStorage("WorkingHoursTo") var workingHoursTo: String = "18:00"
    
    
    let formatter = DateFormatter()
    
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter
    }
    
    
    @State var fromDate: Date = Date()
    @State var toDate: Date = Date()
    
//
//    @State var fromDate: Date = dateFormatter.date(from: workingHoursFrom)!
//    @State var toDate: Date = dateFormatter.date(from: workingHoursTo)!
//
    
    
    var body: some View {
        List {
            Section {
                Toggle(isOn: $isWorkingHours) {
                    Text("Custom Working Hours")
                }
                .toggleStyle(SwitchToggleStyle(tint: .gsGreenPrimary))
                
            } footer: {
                Text("Choose when to allow push notifications to be sent for activity on GitSpace")
            }
            
            
            if isWorkingHours {
                
                Group {
                    // TODO: - 시작점 세팅해야 함
                    Section {
                        DatePicker("From", selection: $fromDate, displayedComponents: .hourAndMinute)
                        
                        DatePicker("To", selection: $toDate, displayedComponents: .hourAndMinute)
                    } header: {
                        Text("SET SCEHDULE")
                    } // Section
                    
                    Section {
                        Button {
                            isWorkingHoursCustom = false
                        } label: {
                            HStack {
                                Text("Every day")
                                    .foregroundColor(.primary)
                                Spacer()
                                Image(systemName: isWorkingHoursCustom
                                      ? "circle"
                                      : "checkmark.circle.fill")
                                .foregroundColor(isWorkingHoursCustom
                                                 ? .gsLightGray2
                                                 : .gsGreenPrimary)
                            }
                        } // Button
                        
                        Button {
                            isWorkingHoursCustom = true
                        } label: {
                            HStack {
                                Text("Custom")
                                    .foregroundColor(.primary)
                                Spacer()
                                Image(systemName: isWorkingHoursCustom
                                      ? "checkmark.circle.fill"
                                      : "circle")
                                .foregroundColor(isWorkingHoursCustom
                                                 ? .gsGreenPrimary
                                                 : .gsLightGray2)
                            }
                        } // Button
                        
                    } // Section
                    
                    if isWorkingHoursCustom {
                        Button {
                            
                        } label: {
                            HStack {
                                Text("Sunday")
                                    .foregroundColor(.primary)
                                Spacer()
                                Image(systemName: isWorkingHoursCustom
                                      ? "checkmark.circle.fill"
                                      : "circle")
                                .foregroundColor(isWorkingHoursCustom
                                                 ? .gsGreenPrimary
                                                 : .gsLightGray2)
                            }
                        } // Button
                        
                        Button {
                            
                        } label: {
                            HStack {
                                Text("Monday")
                                    .foregroundColor(.primary)
                                Spacer()
                                Image(systemName: isWorkingHoursCustom
                                      ? "checkmark.circle.fill"
                                      : "circle")
                                .foregroundColor(isWorkingHoursCustom
                                                 ? .gsGreenPrimary
                                                 : .gsLightGray2)
                            }
                        } // Button
                        
                        Button {
                            
                        } label: {
                            HStack {
                                Text("Tuesday")
                                    .foregroundColor(.primary)
                                Spacer()
                                Image(systemName: isWorkingHoursCustom
                                      ? "checkmark.circle.fill"
                                      : "circle")
                                .foregroundColor(isWorkingHoursCustom
                                                 ? .gsGreenPrimary
                                                 : .gsLightGray2)
                            }
                        } // Button
                        
                        Button {
                            
                        } label: {
                            HStack {
                                Text("Wednesday")
                                    .foregroundColor(.primary)
                                Spacer()
                                Image(systemName: isWorkingHoursCustom
                                      ? "checkmark.circle.fill"
                                      : "circle")
                                .foregroundColor(isWorkingHoursCustom
                                                 ? .gsGreenPrimary
                                                 : .gsLightGray2)
                            }
                        } // Button
                        
                        Button {
                            
                        } label: {
                            HStack {
                                Text("Thursday")
                                    .foregroundColor(.primary)
                                Spacer()
                                Image(systemName: isWorkingHoursCustom
                                      ? "checkmark.circle.fill"
                                      : "circle")
                                .foregroundColor(isWorkingHoursCustom
                                                 ? .gsGreenPrimary
                                                 : .gsLightGray2)
                            }
                        } // Button
                        
                        Button {
                            
                        } label: {
                            HStack {
                                Text("Friday")
                                    .foregroundColor(.primary)
                                Spacer()
                                Image(systemName: isWorkingHoursCustom
                                      ? "checkmark.circle.fill"
                                      : "circle")
                                .foregroundColor(isWorkingHoursCustom
                                                 ? .gsGreenPrimary
                                                 : .gsLightGray2)
                            }
                        } // Button
                        
                        Button {
                            
                        } label: {
                            HStack {
                                Text("Saturday")
                                    .foregroundColor(.primary)
                                Spacer()
                                Image(systemName: isWorkingHoursCustom
                                      ? "checkmark.circle.fill"
                                      : "circle")
                                .foregroundColor(isWorkingHoursCustom
                                                 ? .gsGreenPrimary
                                                 : .gsLightGray2)
                            }
                        } // Button
                    } // if: isWorkingHoursCustom
                } // Group
            } // if: isWorkingHours
        } // List
        .animation(.easeIn, value: [isWorkingHours, isWorkingHoursCustom])
        .transition(.move(edge: .top))
        .navigationBarTitle("Working Hours", displayMode: .inline)
    }
}

struct SetWorkingHoursView_Previews: PreviewProvider {
    static var previews: some View {
        SetWorkingHoursView()
    }
}
