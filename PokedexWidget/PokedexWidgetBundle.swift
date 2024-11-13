//
//  PokedexWidgetBundle.swift
//  PokedexWidget
//
//  Created by Fernando Draghi on 13/11/2024.
//

import WidgetKit
import SwiftUI

@main
struct PokedexWidgetBundle: WidgetBundle {
    var body: some Widget {
        PokedexWidget()
        PokedexWidgetControl()
        PokedexWidgetLiveActivity()
    }
}
