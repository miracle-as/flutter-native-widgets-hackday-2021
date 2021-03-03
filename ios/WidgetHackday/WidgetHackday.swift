//
//  WidgetHackday.swift
//  WidgetHackday
//
//  Created by Jonas L on 03/03/2021.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), counter: CounterDTO(counter: 0), imagePath: nil)
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), counter: CounterDTO(counter: 0), imagePath: nil)
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []
        
        let dir = FileManager.default
                .containerURL(forSecurityApplicationGroupIdentifier: "group.dk.miracle.flutter-native-widget-hackday-2021")!
        let filePath = dir.appendingPathComponent("counter.json")
        let imageFilePath = dir.appendingPathComponent("counter.png")
        
        let data = try! Data(contentsOf: filePath)
        
        let counterDTO = try! JSONDecoder().decode(CounterDTO.self, from: data)
        
        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, counter: counterDTO, imagePath: imageFilePath.path)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct CounterDTO: Codable {
    let counter: Int
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let counter: CounterDTO
    let imagePath: String?
    
//    let counter: Int
}

struct WidgetHackdayEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        VStack {
            Text(entry.date, style: .time)
            Text("\(entry.counter.counter)")
            if let imagePath = entry.imagePath {
                Image(uiImage: UIImage(contentsOfFile: imagePath)!)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.red)
    }
}

@main
struct WidgetHackday: Widget {
    let kind: String = "WidgetHackday"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            WidgetHackdayEntryView(entry: entry)
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}

struct WidgetHackday_Previews: PreviewProvider {
    static var previews: some View {
        WidgetHackdayEntryView(entry: SimpleEntry(date: Date(), counter: CounterDTO(counter: 0), imagePath: nil))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
