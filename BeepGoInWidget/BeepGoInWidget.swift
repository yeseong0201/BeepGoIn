//
//  BeepGoInWidget.swift
//  BeepGoInWidget
//
//  Created by 이예성 on 2021/06/23.
//


import WidgetKit
import SwiftUI
import Intents
import UIKit

struct Provider: IntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        let image = UserDefaults.standard.object(forKey: "image") as! UIImage
        return SimpleEntry(date: Date(), text:"", image: image,
                    configuration: ConfigurationIntent())
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let image = UserDefaults.standard.object(forKey: "image") as! UIImage
        let entry = SimpleEntry(date: Date(),text:"", image: image, configuration: configuration)
        completion(entry)
    }

    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []
        
        let userDefaults = UserDefaults(suiteName: "group.beepgoinwidgetcache")

        let text = userDefaults?.value(forKey: "text") as? String ?? "No text"
        
        let image = UserDefaults.standard.object(forKey: "image") as! UIImage
        
      


//      guard let image = userDefaults?.value(forKey: "image") as? UIImage else{return}

        // Generate a timeline consisting of five entries an hour apa rt, starting from the current date.
        let currentDate = Date()
        
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(
                date: entryDate,
                text: text,
                image: image,
                configuration: configuration)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let text: String
    
    // 이미지 작업
    let image: UIImage
    
    let configuration: ConfigurationIntent
    
}

struct BeepGoInWidgetEntryView : View {
    var entry: Provider.Entry
//    let image = UserDefaults.standard.object(forKey: "image") as! UIImage
    
//    var body: some View {
//            Image(uiImage: image)
//                .resizable().aspectRatio(contentMode: .fill).clipped().frame(width: geo.size.width, height: geo.size.height , alignment: .center)
//
//        }

    var body: some View {
        GeometryReader{ geo in
            VStack{
                Image("Background" ).resizable().aspectRatio(contentMode: .fill).clipped()
                    .frame(width: geo.size.width, height: geo.size.height , alignment: .center)

            }


            Text(entry.text)
                .font(Font.system(size: 24, weight: .semibold, design: .default )).foregroundColor(Color.black)

        }

    }
}

@main
struct BeepGoInWidget: Widget {
    let kind: String = "BeepGoInWidget"
    let image = UserDefaults.standard.object(forKey: "image") as! UIImage
 
    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            BeepGoInWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("BeepGoInWidget")
        .description("This is an example widget.")
    }
}

struct BeepGoInWidget_Previews: PreviewProvider {
    static var previews: some View {
        let image = UserDefaults.standard.object(forKey: "image") as! UIImage
        BeepGoInWidgetEntryView(entry: SimpleEntry(date: Date(),text:"BeepGoIn", image: image , configuration: ConfigurationIntent()))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
