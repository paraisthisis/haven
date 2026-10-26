import SwiftUI
import UIKit

struct Haptics {
    static func softTap() {
        let generator = UIImpactFeedbackGenerator(style: .soft)
        generator.impactOccurred()
    }
    static func warmSuccess() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
    }
}

extension Color {
    static let hearthBg = Color(red: 0.075, green: 0.086, blue: 0.110)
    static let hearthCard = Color(red: 0.115, green: 0.125, blue: 0.155)
    static let hearthGold = Color(red: 0.94, green: 0.76, blue: 0.42)
    static let hearthText = Color(red: 0.90, green: 0.88, blue: 0.84)
    static let hearthSubtext = Color(red: 0.65, green: 0.63, blue: 0.60)
    static let hearthSage = Color(red: 0.45, green: 0.68, blue: 0.58)
}

struct ContentView: View {
    @AppStorage("lowSensoryMode") private var lowSensoryMode: Bool = false
    @State private var selectedTab: Int = 0
    @State private var currentTruthIndex: Int = 0
    
    let truths = [
        "You do not have to earn your rest today. You do not have to be fixed to be worthy of warmth, safety, and kindness.",
        "Your worth is inherent. It does not go up when you are productive or down when you are struggling.",
        "Feelings are weather, not permanent architecture. Even the fiercest storm runs out of rain.",
        "You have survived 100% of your hardest, darkest days so far. You matter.",
        "Being sensitive in a harsh world is not a defect—it means your heart is still alive."
    ]
    
    var body: some View {
        ZStack {
            (lowSensoryMode ? Color(white: 0.1) : Color.hearthBg)
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                HStack {
                    HStack(spacing: 10) {
                        Image(systemName: "flame.fill")
                            .foregroundColor(lowSensoryMode ? .gray : .hearthGold)
                            .font(.title2)
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Hearth & Haven")
                                .font(.system(.headline, design: .serif))
                                .foregroundColor(.hearthText)
                            Text("You matter. Nothing can take that away.")
                                .font(.caption2)
                                .foregroundColor(.hearthSubtext)
                        }
                    }
                    Spacer()
                    Button(action: {
                        Haptics.softTap()
                        lowSensoryMode.toggle()
                    }) {
                        HStack(spacing: 4) {
                            Image(systemName: lowSensoryMode ? "moon.fill" : "moon")
                            Text(lowSensoryMode ? "Quiet: On" : "Quiet: Off")
                        }
                        .font(.caption)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 6)
                        .background(Color.hearthCard)
                        .foregroundColor(.hearthText)
                        .clipShape(Capsule())
                        .overlay(Capsule().stroke(Color.white.opacity(0.15), lineWidth: 1))
                    }
                }
                .padding(.horizontal)
                .padding(.vertical, 12)
                .background(Color.black.opacity(0.2))
                
                VStack(alignment: .leading, spacing: 10) {
                    Text("“\(truths[currentTruthIndex])”")
                        .font(.system(.subheadline, design: .serif))
                        .italic()
                        .foregroundColor(.hearthText)
                        .fixedSize(horizontal: false, vertical: true)
                    
                    HStack {
                        Text("Safe Harbor • Zero Judgment")
                            .font(.caption2)
                            .foregroundColor(.hearthSubtext)
                        Spacer()
                        Button("Another truth →") {
                            Haptics.softTap()
                            currentTruthIndex = (currentTruthIndex + 1) % truths.count
                        }
                        .font(.caption)
                        .foregroundColor(.hearthGold)
                    }
                }
                .padding(14)
                .background(Color.hearthCard)
                .cornerRadius(16)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.hearthGold.opacity(lowSensoryMode ? 0.1 : 0.3), lineWidth: 1)
                )
                .padding(.horizontal)
                .padding(.top, 10)
                
                TabView(selection: $selectedTab) {
                    ReliefRoomsView(lowSensory: lowSensoryMode)
                        .tag(0)
                    CarePackageView()
                        .tag(1)
                    LettersView()
                        .tag(2)
                    LanternWallView()
                        .tag(3)
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                
                HStack {
                    navButton(title: "Rooms", icon: "house.lodge.fill", index: 0)
                    navButton(title: "Care Pack", icon: "cup.and.saucer.fill", index: 1)
                    navButton(title: "Letters", icon: "envelope.open.fill", index: 2)
                    navButton(title: "Lanterns", icon: "sparkles", index: 3)
                }
                .padding(.vertical, 10)
                .padding(.horizontal, 8)
                .background(Color.hearthCard)
            }
        }
        .preferredColorScheme(.dark)
    }
    
    private func navButton(title: String, icon: String, index: Int) -> some View {
        Button(action: {
            Haptics.softTap()
            selectedTab = index
        }) {
            VStack(spacing: 4) {
                Image(systemName: icon)
                    .font(.system(size: 18))
                Text(title)
                    .font(.caption2)
                    .fontWeight(.medium)
            }
            .frame(maxWidth: .infinity)
            .foregroundColor(selectedTab == index ? .hearthGold : .hearthSubtext)
        }
    }
}

struct ReliefRoomsView: View {
    var lowSensory: Bool
    @State private var selectedRoom: String = "GAD"
    let rooms = ["GAD", "Depression", "OCD", "Autism", "BPD"]
    
    @State private var worryText: String = ""
    @AppStorage("lockedWorriesCount") private var lockedWorriesCount: Int = 0
    @State private var worryLockedMessage: Bool = false
    @State private var breatheExpand: Bool = false
    
    @State private var depressionValidation: String = ""
    @State private var ocdThought: String = ""
    @State private var defusedThought: String = ""
    @AppStorage("autismSafeNotes") private var autismSafeNotes: String = ""
    @State private var bpdIntensity: Double = 5
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(rooms, id: \.self) { room in
                            Button(action: {
                                Haptics.softTap()
                                selectedRoom = room
                            }) {
                                Text(room)
                                    .font(.caption)
                                    .fontWeight(.semibold)
                                    .padding(.horizontal, 14)
                                    .padding(.vertical, 8)
                                    .background(selectedRoom == room ? Color.hearthGold.opacity(0.25) : Color.hearthCard)
                                    .foregroundColor(selectedRoom == room ? .hearthGold : .hearthText)
                                    .clipShape(Capsule())
                                    .overlay(
                                        Capsule().stroke(selectedRoom == room ? Color.hearthGold : Color.white.opacity(0.1), lineWidth: 1)
                                    )
                            }
                        }
                    }
                }
                
                if selectedRoom == "GAD" {
                    gadView
                } else if selectedRoom == "Depression" {
                    depressionView
                } else if selectedRoom == "OCD" {
                    ocdView
                } else if selectedRoom == "Autism" {
                    autismView
                } else if selectedRoom == "BPD" {
                    bpdView
                }
            }
            .padding()
        }
    }
    
    private var gadView: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Worry Containment & Vagus Reset")
                .font(.system(.title3, design: .serif))
                .foregroundColor(.hearthGold)
            Text("Your brain is trying to protect you by scanning for danger. Let's physically signal safety to your nervous system.")
                .font(.caption)
                .foregroundColor(.hearthSubtext)
            
            VStack(spacing: 12) {
                ZStack {
                    Circle()
                        .fill(Color.hearthGold.opacity(0.18))
                        .frame(width: 120, height: 120)
                        .scaleEffect(lowSensory ? 1.0 : (breatheExpand ? 1.35 : 0.85))
                        .animation(lowSensory ? .none : .easeInOut(duration: 5).repeatForever(autoreverses: true), value: breatheExpand)
                    
                    Text("4s In\n4s Hold\n6s Out")
                        .font(.caption)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.hearthText)
                }
                .frame(height: 160)
                .onAppear { breatheExpand = true }
                
                Text("Longer exhales activate the vagus nerve and slow your heart rate.")
                    .font(.caption2)
                    .foregroundColor(.hearthSubtext)
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.black.opacity(0.25))
            .cornerRadius(14)
            
            VStack(alignment: .leading, spacing: 8) {
                Text("The Iron Worry Box (\(lockedWorriesCount) held safely for you)")
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(.hearthText)
                
                HStack {
                    TextField("Type what's scaring you...", text: $worryText)
                        .textFieldStyle(.plain)
                        .padding(10)
                        .background(Color.black.opacity(0.3))
                        .cornerRadius(10)
                        .font(.subheadline)
                    
                    Button("Lock Away") {
                        guard !worryText.trimmingCharacters(in: .whitespaces).isEmpty else { return }
                        Haptics.warmSuccess()
                        lockedWorriesCount += 1
                        worryText = ""
                        worryLockedMessage = true
                    }
                    .font(.caption)
                    .fontWeight(.semibold)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 10)
                    .background(Color.hearthGold.opacity(0.3))
                    .foregroundColor(.hearthGold)
                    .cornerRadius(10)
                }
                
                if worryLockedMessage {
                    Text("🔒 Locked safely outside your head. You have permission to put this down for the next hour.")
                        .font(.caption)
                        .foregroundColor(.hearthSage)
                }
            }
        }
        .padding()
        .background(Color.hearthCard)
        .cornerRadius(16)
    }
    
    private var depressionView: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Zero-Guilt Nourishment Menu")
                .font(.system(.title3, design: .serif))
                .foregroundColor(.hearthGold)
            Text("Surviving heavy gravity takes enormous strength. Tap any tiny step below—every single one counts as a complete victory.")
                .font(.caption)
                .foregroundColor(.hearthSubtext)
            
            nourishButton(
                label: "🛌 0% Battery: Unclench your jaw & blink",
                validation: "You stayed alive and present for another moment. When gravity is this heavy, that is heroic."
            )
            nourishButton(
                label: "💧 2% Battery: Take one sip of water",
                validation: "Water is life. Even one single sip is an act of physical kindness to your cells."
            )
            nourishButton(
                label: "🧣 5% Battery: Pull a blanket over your shoulders",
                validation: "Wrapping yourself in warmth gives your nervous system a physical boundary of safety."
            )
            nourishButton(
                label: "🌤️ 10% Battery: Look out a window for 15 seconds",
                validation: "Looking at the sky or trees reminds your brain that the world is still gently turning for you."
            )
            
            if !depressionValidation.isEmpty {
                HStack(alignment: .top, spacing: 8) {
                    Image(systemName: "heart.fill")
                        .foregroundColor(.hearthGold)
                    Text(depressionValidation)
                        .font(.caption)
                        .foregroundColor(.hearthText)
                }
                .padding()
                .background(Color.hearthSage.opacity(0.2))
                .cornerRadius(12)
            }
        }
        .padding()
        .background(Color.hearthCard)
        .cornerRadius(16)
    }
    
    private func nourishButton(label: String, validation: String) -> some View {
        Button(action: {
            Haptics.warmSuccess()
            depressionValidation = validation
        }) {
            HStack {
                Text(label)
                    .font(.subheadline)
                    .foregroundColor(.hearthText)
                    .multilineTextAlignment(.leading)
                Spacer()
                Image(systemName: "checkmark.circle")
                    .foregroundColor(.hearthGold)
            }
            .padding(12)
            .background(Color.black.opacity(0.25))
            .cornerRadius(12)
        }
    }
    
    private var ocdView: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Intrusive Loop Separator")
                .font(.system(.title3, design: .serif))
                .foregroundColor(.hearthGold)
            Text("OCD attacks the exact things you love and value most. Intrusive thoughts are ego-dystonic static—the exact opposite of who you are.")
                .font(.caption)
                .foregroundColor(.hearthSubtext)
            
            TextField("What is the noisy loop saying?", text: $ocdThought)
                .textFieldStyle(.plain)
                .padding(10)
                .background(Color.black.opacity(0.3))
                .cornerRadius(10)
                .font(.subheadline)
            
            Button("Separate Static from My True Self") {
                guard !ocdThought.trimmingCharacters(in: .whitespaces).isEmpty else { return }
                Haptics.softTap()
                defusedThought = ocdThought
                ocdThought = ""
            }
            .font(.caption)
            .fontWeight(.semibold)
            .frame(maxWidth: .infinity)
            .padding(10)
            .background(Color.hearthGold.opacity(0.25))
            .foregroundColor(.hearthGold)
            .cornerRadius(10)
            
            if !defusedThought.isEmpty {
                VStack(alignment: .leading, spacing: 6) {
                    Text("Cognitive Defusion:")
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundColor(.hearthGold)
                    Text("You are currently noticing a random electrical misfire that says \"\(defusedThought)\". Having that alarm ring does not mean you want it, agree with it, or need to solve it. Let it float past like a cloud.")
                        .font(.caption)
                        .foregroundColor(.hearthText)
                }
                .padding()
                .background(Color.black.opacity(0.3))
                .cornerRadius(12)
            }
        }
        .padding()
        .background(Color.hearthCard)
        .cornerRadius(16)
    }
    
    private var autismView: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("The Unmasking Sanctuary")
                .font(.system(.title3, design: .serif))
                .foregroundColor(.hearthGold)
            Text("No eye contact required. No tone policing. No social decoding. You are completely safe to drop the mask here.")
                .font(.caption)
                .foregroundColor(.hearthSubtext)
            
            VStack(alignment: .leading, spacing: 8) {
                Text("✓ Full permission to stim, rock, or sit in total silence.")
                Text("✓ You do not owe anyone a facial expression right now.")
                Text("✓ Your sensory limits are real physical boundaries, not flaws.")
            }
            .font(.caption)
            .foregroundColor(.hearthText)
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.black.opacity(0.25))
            .cornerRadius(12)
            
            Text("Special Interest / Safe Brain Dump (Auto-saved on your iPhone):")
                .font(.caption)
                .foregroundColor(.hearthSubtext)
            
            TextEditor(text: $autismSafeNotes)
                .frame(height: 110)
                .scrollContentBackground(.hidden)
                .padding(8)
                .background(Color.black.opacity(0.3))
                .cornerRadius(10)
                .font(.caption)
                .foregroundColor(.hearthText)
        }
        .padding()
        .background(Color.hearthCard)
        .cornerRadius(16)
    }
    
    private var bpdView: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("The Emotional Tsunami Harbor")
                .font(.system(.title3, design: .serif))
                .foregroundColor(.hearthGold)
            Text("When emotional skin feels nonexistent, pain feels infinite. Let's anchor until the wave crests.")
                .font(.caption)
                .foregroundColor(.hearthSubtext)
            
            VStack(alignment: .leading, spacing: 6) {
                Text("Distress Thermometer: \(Int(bpdIntensity))/10")
                    .font(.caption)
                    .fontWeight(.semibold)
                Slider(value: $bpdIntensity, in: 1...10, step: 1)
                    .tint(.hearthGold)
                
                if bpdIntensity >= 8 {
                    Text("🧊 High Distress Alert (TIPP Skill): Your nervous system is on fire. Go hold an ice cube tightly in your hand or splash cold water over your eyes/cheeks for 15 seconds. This triggers the mammalian dive reflex and biologically drops your heart rate immediately.")
                        .font(.caption)
                        .foregroundColor(.hearthGold)
                        .padding(10)
                        .background(Color.black.opacity(0.35))
                        .cornerRadius(10)
                }
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text("EMOTIONAL PERMANENCE VAULT")
                    .font(.caption2)
                    .fontWeight(.bold)
                    .foregroundColor(.hearthGold)
                Text("• Distance is not abandonment: When people are quiet or busy, their love for you has not vanished.")
                Text("• Having an overwhelming emotion does not make you 'too much' or unlovable.")
                Text("• Intense emotional spikes chemically crest and begin to recede within 20 minutes. Stay anchored.")
            }
            .font(.caption)
            .foregroundColor(.hearthText)
            .padding()
            .background(Color.black.opacity(0.25))
            .cornerRadius(12)
        }
        .padding()
        .background(Color.hearthCard)
        .cornerRadius(16)
    }
}

struct CarePackageView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                careCard(
                    badge: "📜 POEM FOR HEAVY DAYS",
                    title: "“Wild Geese” — Mary Oliver",
                    content: "You do not have to be good.\nYou do not have to walk on your knees\nfor a hundred miles through the desert, repenting.\nYou only have to let the soft animal of your body\nlove what it loves."
                )
                careCard(
                    badge: "🎬 ZERO-THREAT COMFORT MOVIES",
                    title: "Safe Worlds to Escape Into",
                    content: "• My Neighbor Totoro & Kiki's Delivery Service: Pure gentle humanity, warm rain, and zero cruelty.\n\n• Paddington 2: Unconditional kindness triumphing in a cynical world.\n\n• The Secret World of Arrietty: Quiet, miniature cozy craftsmanship.\n\n• All Creatures Great and Small: Soft hills, gentle empathy, and warm tea."
                )
                careCard(
                    badge: "📚 SOUL-NOURISHING BOOKS",
                    title: "Gentle Companions",
                    content: "• The Boy, the Mole, the Fox and the Horse (Charlie Mackesy)\n\n• A Psalm for the Wild-Built (Becky Chambers)\n\n• Wintering (Katherine May)"
                )
            }
            .padding()
        }
    }
    
    private func careCard(badge: String, title: String, content: String) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(badge)
                .font(.caption2)
                .fontWeight(.bold)
                .foregroundColor(.hearthGold)
            Text(title)
                .font(.system(.headline, design: .serif))
                .foregroundColor(.hearthText)
            Text(content)
                .font(.caption)
                .foregroundColor(.hearthSubtext)
                .lineSpacing(3)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.hearthCard)
        .cornerRadius(16)
    }
}

struct LettersView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                letterCard(
                    title: "For when you feel like a burden",
                    bodyText: "Your brain is lying to you right now. Needing gentleness, reassurance, patience, or help does not make you a weight on the world. Humans were never meant to survive in isolation."
                )
                letterCard(
                    title: "For 3:00 AM when the night feels endless",
                    bodyText: "Nighttime strips away distractions and magnifies every fear. Never trust how your life looks at 3:00 AM. You don't have to figure out your future tonight. Your only job until sunrise is to breathe."
                )
                letterCard(
                    title: "For when you feel behind in life",
                    bodyText: "You are not running the same race as people who haven't had to fight their own nervous system just to survive the day. Healing is invisible work. Every ounce of energy you spent staying alive counts."
                )
            }
            .padding()
        }
    }
    
    private func letterCard(title: String, bodyText: String) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.system(.headline, design: .serif))
                .foregroundColor(.hearthGold)
            Text(bodyText)
                .font(.caption)
                .foregroundColor(.hearthText)
                .lineSpacing(4)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.hearthCard)
        .cornerRadius(16)
    }
}

struct LanternWallView: View {
    @AppStorage("savedLanterns") private var savedLanternsData: String = "I made it through a panic attack tonight. Holding a warm mug for anyone else awake right now.||Please stay. Even if today was only 1% bearable, tomorrow has moments you haven't met yet.||Unclenching my shoulders and sending quiet warmth to you."
    @State private var newLanternText: String = ""
    
    var lanterns: [String] {
        savedLanternsData.components(separatedBy: "||").filter { !$0.isEmpty }
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 14) {
                Text("The Sanctuary Lantern Wall")
                    .font(.system(.title3, design: .serif))
                    .foregroundColor(.hearthGold)
                Text("Light a lantern with a note of kindness or survival for yourself whenever you return here.")
                    .font(.caption)
                    .foregroundColor(.hearthSubtext)
                
                HStack {
                    TextField("Leave a warm note...", text: $newLanternText)
                        .textFieldStyle(.plain)
                        .padding(10)
                        .background(Color.black.opacity(0.3))
                        .cornerRadius(10)
                        .font(.subheadline)
                    
                    Button("🏮 Light") {
                        let trimmed = newLanternText.trimmingCharacters(in: .whitespaces)
                        guard !trimmed.isEmpty else { return }
                        Haptics.warmSuccess()
                        savedLanternsData = trimmed + "||" + savedLanternsData
                        newLanternText = ""
                    }
                    .font(.caption)
                    .fontWeight(.semibold)
                    .padding(.horizontal, 14)
                    .padding(.vertical, 10)
                    .background(Color.hearthGold.opacity(0.3))
                    .foregroundColor(.hearthGold)
                    .cornerRadius(10)
                }
                
                ForEach(lanterns, id: \.self) { note in
                    HStack(alignment: .top, spacing: 10) {
                        Text("🏮")
                        Text(note)
                            .font(.caption)
                            .foregroundColor(.hearthText)
                    }
                    .padding(12)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color.black.opacity(0.25))
                    .cornerRadius(12)
                }
            }
            .padding()
            .background(Color.hearthCard)
            .cornerRadius(16)
            .padding()
        }
    }
}
