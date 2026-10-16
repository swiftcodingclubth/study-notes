import Foundation
import SwiftData

@Model
final class Note {
    var title: String
    var body: String
    var summary: String?
    var tags: [String] = []
    var updatedAt: Date = Date.now

    init(title: String, body: String) {
        self.title = title
        self.body = body
    }
}

extension Note {
    static let samples: [(title: String, body: String)] = [
        (
            "Photosynthesis",
            """
            Photosynthesis is how plants, algae and some bacteria turn light energy into chemical energy. \
            It happens in the chloroplasts, which contain the green pigment chlorophyll.

            The light-dependent reactions take place in the thylakoid membranes. They split water molecules, \
            release oxygen and make ATP and NADPH.

            The Calvin cycle takes place in the stroma. It uses ATP, NADPH and carbon dioxide from the air \
            to build glucose.

            Overall equation: 6CO2 + 6H2O + light energy -> C6H12O6 + 6O2.
            Factors that change the rate: light intensity, carbon dioxide concentration and temperature.
            """
        ),
        (
            "The French Revolution",
            """
            The French Revolution began in 1789 and ended in 1799 when Napoleon Bonaparte took power.

            Causes: France was deeply in debt after the Seven Years' War and the American Revolution, \
            bread prices were very high, and the Third Estate paid most of the taxes but had little power.

            Key events: the Estates-General met in May 1789. The Third Estate formed the National Assembly \
            and swore the Tennis Court Oath. On 14 July 1789 crowds stormed the Bastille. \
            The Declaration of the Rights of Man and of the Citizen was adopted in August 1789. \
            King Louis XVI was executed in 1793, and the Reign of Terror under Robespierre followed.

            Legacy: the ideas of liberty, equality and fraternity spread across Europe.
            """
        ),
        (
            "Newton's Laws of Motion",
            """
            First law (inertia): an object stays at rest or keeps moving at a constant velocity \
            unless a net force acts on it.

            Second law: the net force on an object equals its mass times its acceleration, F = ma. \
            Force is measured in newtons (N). 1 N = 1 kg·m/s².

            Third law: for every action there is an equal and opposite reaction. \
            When you push on a wall, the wall pushes back on you with the same force.

            Example: a 2 kg ball pushed with a net force of 10 N accelerates at 5 m/s².
            Friction and air resistance are forces that often oppose motion.
            """
        ),
        (
            "The Water Cycle",
            """
            The water cycle is the continuous movement of water on, above and below the surface of the Earth. \
            The Sun provides the energy that drives it.

            Evaporation: heat turns liquid water from oceans, lakes and rivers into water vapour. \
            Transpiration: plants release water vapour through their leaves.
            Condensation: water vapour cools in the atmosphere and forms clouds.
            Precipitation: water falls back to the ground as rain, snow, sleet or hail.
            Collection: water gathers in oceans, rivers and lakes, or soaks into the ground as groundwater.

            About 97% of the Earth's water is salt water in the oceans.
            """
        ),
        (
            "The Ayutthaya Kingdom",
            """
            The Ayutthaya Kingdom was founded in 1351 by King U Thong (Ramathibodi I) and lasted until 1767.

            Its capital was on an island where the Chao Phraya, Lopburi and Pa Sak rivers meet, \
            which made it a major trading port. Merchants came from China, Japan, Persia, Portugal, \
            the Netherlands and France.

            King Narai the Great (reigned 1656 to 1688) built strong ties with France \
            and sent embassies to the court of Louis XIV.

            The kingdom fell in 1767 when the Burmese army captured and burned the capital. \
            King Taksin then reunited the country and founded the Thonburi Kingdom.
            """
        ),
        (
            "Supply and Demand",
            """
            Demand is how much of a good people want to buy at each price. \
            The law of demand says that when the price goes up, the quantity demanded goes down.

            Supply is how much of a good sellers want to sell at each price. \
            The law of supply says that when the price goes up, the quantity supplied goes up.

            The equilibrium price is where the supply and demand curves cross. \
            If the price is above equilibrium there is a surplus. If it is below equilibrium there is a shortage.

            Example: when a new phone launches and stock is low, prices rise until demand matches supply.
            """
        ),
    ]

    @MainActor
    static func seedIfNeeded(in context: ModelContext) {
        let count = (try? context.fetchCount(FetchDescriptor<Note>())) ?? 0
        guard count == 0 else { return }

        for (index, sample) in samples.enumerated() {
            let note = Note(title: sample.title, body: sample.body)
            note.updatedAt = Date.now.addingTimeInterval(Double(-index) * 3600)
            context.insert(note)
        }
        try? context.save()
    }

    @MainActor
    static var preview: Note {
        let descriptor = FetchDescriptor<Note>(sortBy: [SortDescriptor(\.updatedAt, order: .reverse)])
        return try! ModelContainer.preview.mainContext.fetch(descriptor).first!
    }
}

extension ModelContainer {
    @MainActor
    static let preview: ModelContainer = {
        let container = try! ModelContainer(
            for: Note.self,
            configurations: ModelConfiguration(isStoredInMemoryOnly: true)
        )
        Note.seedIfNeeded(in: container.mainContext)
        return container
    }()
}
