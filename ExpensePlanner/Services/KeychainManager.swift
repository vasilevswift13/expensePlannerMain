
import Foundation
import KeychainSwift


final class KeychainManager {
    
    static let shared = KeychainManager()
    private let keychain = KeychainSwift()
    
    private init() {}
    
    func save(email: String, password: String) {
        keychain.set(email, forKey: "userEmail")
        keychain.set(password, forKey: "userPassword_\(email)") // пароль вяжем к мылу
        
        print("Сохраняем данные в кейчейн")
    }
    
    func getPassword(email: String) -> String? {
        let password = keychain.get("userPassword_\(email)")
        print("Пароль для \(email) получен из Keychain")
        return password
    }
    
    // получаем сохраненное мыло
    
    func getEmail() -> String? {
        return keychain.get("userEmail")
    }
    
    // очистка всех данных пользователя при выходе
    
    func clear() {
        if let email = getEmail() {
            keychain.delete("userPassword_\(email)")
        }
        keychain.delete("userEmail")
        print("Данные пользователя удалены из Keychain")
    }
    
}


