import SwiftUI
import UniformTypeIdentifiers

// 单条消息模型
struct Message: Identifiable {
    let id = UUID()
    let text: String
    let isUser: Bool
}

// 聊天主界面
struct ChatView: View {
    @State private var messages: [Message] = []
    @State private var inputText: String = ""
    @State private var showFilePicker = false
    
    var body: some View {
        VStack(spacing: 0) {
            // 消息列表
            ScrollView {
                LazyVStack(spacing: 12) {
                    ForEach(messages) { msg in
                        HStack {
                            if msg.isUser {
                                Spacer()
                                Text(msg.text)
                                    .padding(12)
                                    .background(Color.blue)
                                    .foregroundColor(.white)
                                    .cornerRadius(16)
                                    .frame(maxWidth: 260, alignment: .trailing)
                            } else {
                                Text(msg.text)
                                    .padding(12)
                                    .background(Color(.systemGray5))
                                    .cornerRadius(16)
                                    .frame(maxWidth: 260, alignment: .leading)
                                Spacer()
                            }
                        }
                        .padding(.horizontal, 12)
                    }
                }
                .padding(.vertical, 12)
            }
            
            // 输入框区域
            HStack {
                TextField("输入消息...", text: $inputText)
                    .textFieldStyle(.roundedBorder)
                
                Button("发送") {
                    sendMessage()
                }
                .buttonStyle(.borderedProminent)
            }
            .padding(12)
        }
        .navigationTitle("LocalChat Luna")
        .toolbar {
            // 导入按钮
            Button("导入DeepSeek记录") {
                showFilePicker = true
            }
        }
        .fileImporter(
            isPresented: $showFilePicker,
            allowedContentTypes: [.json],
            allowsMultipleSelection: false
        ) { result in
            do {
                let url = try result.get().first!
                let data = try Data(contentsOf: url)
                let importedMsg = try ImportManager.parseDeepSeekJSON(data: data)
                messages.append(contentsOf: importedMsg)
            } catch {
                print("导入失败：\(error)")
            }
        }
    }
    
    func sendMessage() {
        guard !inputText.isEmpty else { return }
        // 添加用户消息
        messages.append(Message(text: inputText, isUser: true))
        let sendContent = inputText
        inputText = ""
        
        // 这里以后对接本地模型，现在先模拟回复
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            messages.append(Message(text: "收到你的消息：\(sendContent)", isUser: false))
        }
    }
}

#Preview {
    NavigationStack {
        ChatView()
    }
}
