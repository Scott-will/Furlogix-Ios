//
//  DIContainer.swift
//  Vet App
//
//  Created by Scott Williams on 2024-12-10.
//

final class DIContainer {

    static let shared = DIContainer()

    private init() {}

    var services: [String: Any] = [:]

    func register<Service>(type: Service.Type, service: Any) {
      services["\(type)"] = service
    }

    func resolve<Service>(type: Service.Type) -> Service? {
    return services["\(type)"] as? Service
    }
    
    //register all services for dependency injection
    static func registerAllServices(){
        shared.register(type: UserRepositoryProtocol.self, service: UserRepository())
        shared.register(type: PetRepositoryProtocol.self, service: PetRepository())
        shared.register(type: ReportRepositoryProtocol.self, service: ReportRepository())
        shared.register(type: ReportTemplateRepositoryProtocol.self, service: ReportTemplateRepository())
        shared.register(type: ReminderRepositoryProtocol.self, service: ReminderRepository())
        shared.register(type: ReportEntryRepositoryProtocol.self, service: ReportEntryRepository())
    }
}
