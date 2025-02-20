//
//  LabelText.swift
//  noStress15
//
//  Created by Diana on 20/02/2025.
//
import Foundation

enum LabelText: String {
    case instructionTitle = "instruction_title"
    case instructionText = "instruction_text"
    
    case donateTitle = "donate_title"
    case usdtLabel = "usdt_label"
    case copyButton = "copy_button"
    case thankYou = "thank_you"
    case copiedText = "copied_text"

    case homeInstruction = "home_instruction"
    case homeTimer = "home_timer"
    case homeStats = "home_stats"
    case homeSettings = "home_settings"
    case appName = "app_name"

    case nextButton = "next_button"

    case secondsLabel = "seconds_label"

    case statsDay = "stats_day"
    case statsWeek = "stats_week"
    case statsMonth = "stats_month"
    case clearHistory = "clear_history"
    case averageDuration = "average_duration"
    case recordLabel = "record_label"
    case sessionsLabel = "sessions_label"
    case minutesLabel = "minutes_label"

    var text: String {
        return NSLocalizedString(self.rawValue, comment: "")
    }
}

