//
//  com_rym_widget.swift
//  com.rym.widget
//
//  Created by Yauheni Skiruk on 29.09.22.
//

import WidgetKit
import SwiftUI
import CoreData

struct Provider: TimelineProvider {
    let coreDataStack = CoreDataStack()

    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), remainders: [])
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), remainders: [])
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []
        var remainders: [MedicineRemainder] = []

        let fetchRequest = NSFetchRequest<MedicineRemainder>(entityName: "MedicineRemainder")
        do {
            remainders = try coreDataStack.persistentContainer.viewContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error)")
        }

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, remainders: remainders)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let remainders: [MedicineRemainder]
}

struct RymWidgetEntryView : View {
    @Environment(\.widgetFamily) var family
    var entry: Provider.Entry

    var body: some View {
        switch family {
        case .systemMedium:
            RYMWidgetView(remainders: entry.remainders)
        case .systemLarge:
            RYMWidgetView(remainders: entry.remainders)
        case .accessoryCircular:
            CircuralWidgetView(remainders: entry.remainders)
        case .accessoryInline:
            InlineWidgetView(remainders: entry.remainders)
        default:
            Text("no")
        }

    }
}

@main
struct RymWidget: Widget {
    let kind: String = "com_rym_widget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            RymWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
        .supportedFamilies([.systemLarge, .systemMedium, .accessoryCircular, .accessoryInline])
    }
}

struct com_rym_widget_Previews: PreviewProvider {
    static var previews: some View {
        RymWidgetEntryView(entry: SimpleEntry(date: Date(), remainders: []))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
