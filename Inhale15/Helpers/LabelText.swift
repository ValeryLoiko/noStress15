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
    case donateText = "donate_text"
    case donateWarning = "donate_warning"
    case donateErrortext = "donate_warning_text"
    case usdtLabel = "usdt_label"
    case copyButton = "copy_button"
    case thankYou = "thank_you"
    case copiedText = "copied_text"

    case homeInstruction = "home_instruction"
    case homeTimer = "home_timer"
    case homeStats = "home_stats"
    case homeLanguage = "home_language"
    case homeSettings = "home_settings"
    case homeDonate = "home_donate"
    case appName = "app_name"
    
    case nextButton = "next_button"
    case startButton = "start_button"
    case pauseButton = "pause_button"
    case musicButton = "musicButton" 
    case statisticButton = "statistic_button"
    case sec15Button = "15sec_button"
    case cleanButton = "clean_button"
    case linkKopped = "link_coppied"
    case linkMessage = "link_message"

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

