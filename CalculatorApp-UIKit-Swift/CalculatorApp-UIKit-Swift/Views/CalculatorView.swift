import Foundation

final class CalculatorViewModel {
    
    // MARK: - Properties
    private var currentInput: String = "0"
    private var previousInput: String = ""
    private var operation: OperatorType?
    
    var displayText: String {
        return currentInput
    }
    
    // MARK: - Public Methods
    func handleInput(_ input: String) {
        switch input {
        case "C":
            clear()
        case "⌫":
            deleteLast()
        case "+", "-", "x", "/":
            setOperation(OperatorType(rawValue: input) ?? .none)
        case "=":
            calculateResult()
        case "±":
            toggleSign()
        case ".":
            addDecimal()
        default:
            appendNumber(input)
        }
    }
    
    // MARK: - Private Methods
    private func clear() {
        currentInput = "0"
        previousInput = ""
        operation = nil
    }
    
    private func deleteLast() {
        currentInput = String(currentInput.dropLast())
        if currentInput.isEmpty || currentInput == "-" {
            currentInput = "0"
        }
    }
    
    private func setOperation(_ op: OperatorType) {
        guard !currentInput.isEmpty, op != .none else { return }
        previousInput = currentInput
        currentInput = "0"
        operation = op
    }
    
    private func calculateResult() {
        guard let op = operation, let prev = Double(previousInput), let curr = Double(currentInput) else { return }
        
        let result: Double
        switch op {
        case .addition: result = prev + curr
        case .subtraction: result = prev - curr
        case .multiplication: result = prev * curr
        case .division:
            guard curr != 0 else {
                currentInput = "Error"
                return
            }
            result = prev / curr
        case .none:
            return
        }
        
        currentInput = CalculatorHelper.formatResult(result)
        previousInput = ""
        operation = nil
    }
    
    private func appendNumber(_ number: String) {
        if currentInput == "0" || currentInput == "-0" {
            currentInput = number
        } else {
            currentInput.append(number)
        }
    }
    
    private func addDecimal() {
        guard !currentInput.contains(".") else { return }
        currentInput.append(".")
    }
    
    private func toggleSign() {
        guard let number = Double(currentInput) else { return }
        currentInput = CalculatorHelper.formatResult(-number)
    }
}

// MARK: - Operator Enum
private enum OperatorType: String {
    case addition = "+"
    case subtraction = "-"
    case multiplication = "x"
    case division = "/"
    case none
}
