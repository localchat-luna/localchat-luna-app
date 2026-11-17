import Foundation

// DeepSeek导出对话解析、转成我们App的消息格式
struct DeepSeekMessageItem: Codable {
    let role: String
    let content: String
}

struct DeepSeekConversation: Codable {
    let messages: [DeepSeekMessageItem]
}

class ImportManager {
    // 解析DeepSeek的JSON文件，输出[Message]
    static func parseDeepSeekJSON(data: Data) throws -> [Message] {
        let conversation = try JSONDecoder().decode(DeepSeekConversation.self, from: data)
        var result: [Message] = []
        for item in conversation.messages {
            let isUser = item.role == "user"
            result.append(Message(text: item.content, isUser: isUser))
        }
        return result
    }
}
