import SwiftUI
import Tonic

public struct Key: View {

    var note: Note

    public var body: some View {
        Rectangle()
            .frame(width: 44, height: 200)
            .foregroundColor(.red)
    }
}

public struct Keyboard: View {

    let notes = (0...127).map({ Pitch($0).note(in: .C) })

    public var body: some View {
        HStack {
            ForEach(notes, id: \.self) { note in
                Key(note: note)
            }
        }
    }
}

struct Keyboard_Previews: PreviewProvider {
    static var previews: some View {
        Keyboard()
    }
}
