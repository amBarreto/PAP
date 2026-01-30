import 'package:flutter/material.dart';
import '../models/mensagem.dart';
import '../services/ia_service.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class ChatIAPage extends StatefulWidget {
  final bool showAppBar;

  const ChatIAPage({
    super.key,
    this.showAppBar = true,
  });

  @override
  State<ChatIAPage> createState() => _ChatIAPageState();
}

class _ChatIAPageState extends State<ChatIAPage> {
  final List<Mensagem> mensagens = [];
  final TextEditingController messageController = TextEditingController();
  final ScrollController scrollController = ScrollController(); 
  final IAService iaService = IAService(); //serviço IA
  
  bool isLoading = false;
  bool isOnline = false;

  @override
  void initState() {
    super.initState();
    verificarStatus();
    adicionarMensagemBemVinda();
  }

  Future<void> verificarStatus() async { // /health
    final status = await iaService.verificarStatus();
    setState(() => isOnline = status);
  }

  void adicionarMensagemBemVinda() {
    setState(() {
      mensagens.add(Mensagem(
        texto: 'Olá! 👋 Sou o assistente de saúde do MediHora.\n\n'
            'Posso ajudar com informações gerais sobre medicamentos e saúde.\n\n'
            '⚠️ Lembra-te: Não substituo um médico! Em caso de emergência, liga 112.',
        isUser: false,
        timestamp: DateTime.now(),
      ));
    });
  }

  Future<void> enviarMensagem() async {
    if (messageController.text.trim().isEmpty) return;

    final texto = messageController.text.trim();
    messageController.clear();

    // Adiciona mensagem do utilizador
    setState(() {
      mensagens.add(Mensagem(
        texto: texto,
        isUser: true,
        timestamp: DateTime.now(),
      ));
      isLoading = true;
    });

    scrollToBottom();

    // Chama a IA
    final resposta = await iaService.perguntar(texto); //render -> main.py -> IA

    // Adiciona resposta da IA
    setState(() {
      mensagens.add(Mensagem(
        texto: resposta,
        isUser: false,
        timestamp: DateTime.now(),
      ));
      isLoading = false;
    });

    scrollToBottom();
  }

  void scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  //UI
  @override
  Widget build(BuildContext context) {

      final isDark = Theme.of(context).brightness == Brightness.dark;  //dark mode

    return Scaffold(
      appBar: widget.showAppBar
          ? AppBar(
              title: const Text('🤖 Assistente IA'),
              centerTitle: true,
              actions: [
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: isOnline ? Colors.green.shade100 : Colors.red.shade100,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            isOnline ? Icons.cloud_done : Icons.cloud_off,
                            color: isOnline ? Colors.green : Colors.red,
                            size: 16,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            isOnline ? 'Online' : 'Offline',
                            style: TextStyle(
                              color: isOnline ? Colors.green.shade900 : Colors.red.shade900,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            )
          : null,
      body: Column(
        children: [
          // Lista de mensagens
          Expanded(
            child: mensagens.isEmpty
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : ListView.builder(
                    controller: scrollController,
                    padding: const EdgeInsets.all(16),
                    itemCount: mensagens.length,
                    itemBuilder: (context, index) {
                      final msg = mensagens[index];
                      return ChatBubble(mensagem: msg);
                    },
                  ),
          ),

          // Indicador de carregamento
          if (isLoading)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  const SizedBox(width: 16),
                  SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.teal,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'Pensando...',
                    style: TextStyle(
                      color: Colors.grey,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),

          // Campo de input
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: SafeArea(
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: messageController,
                      decoration: InputDecoration(
                        hintText: 'Faz uma pergunta...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        filled: true,
                        fillColor: isDark
                            ? Colors.grey.shade800
                            : Colors.grey.shade200,
                      ),
                      maxLines: null,
                      textInputAction: TextInputAction.send,
                      onSubmitted: (_) => enviarMensagem(),
                      enabled: !isLoading,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.teal,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      onPressed: isLoading ? null : enviarMensagem,
                      icon: const Icon(Icons.send, color: Colors.white),
                      iconSize: 24,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Widget para bolhas de chat

class ChatBubble extends StatelessWidget {
  final Mensagem mensagem;

  const ChatBubble({super.key, required this.mensagem});

  @override
  Widget build(BuildContext context) {

    final isDark = Theme.of(context).brightness == Brightness.dark;  //dark mode

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment: mensagem.isUser 
            ? MainAxisAlignment.end 
            : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!mensagem.isUser) ...[
            CircleAvatar(
              backgroundColor: Colors.teal,
              child: const Icon(Icons.smart_toy, color: Colors.white, size: 20),
              radius: 16,
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: mensagem.isUser
                    ? Colors.teal
                    : (isDark ? Colors.grey.shade800 
                    : Colors.grey.shade200),
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(16),
                  topRight: const Radius.circular(16),
                  bottomLeft: Radius.circular(mensagem.isUser ? 16 : 4),
                  bottomRight: Radius.circular(mensagem.isUser ? 4 : 16),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MarkdownBody( 
                    data: mensagem.texto,
                    styleSheet: MarkdownStyleSheet(  //estilos markdown (negrito, itálico, listas, etc)
                      p: TextStyle(
                        color: mensagem.isUser ? Colors.white : 
                            isDark ? Colors.white70 
                            : Colors.black87, 
                        fontSize: 15,
                        height: 1.4,
                      ),

                      strong: TextStyle(
                        color: mensagem.isUser ? Colors.white :
                            isDark ? Colors.white70 
                            : Colors.black87,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),

                      em: TextStyle(
                        color: mensagem.isUser ? Colors.white : 
                            isDark ? Colors.white70 
                            :Colors.black87, 
                        fontStyle: FontStyle.italic,
                        fontSize: 15,
                      ),

                      listBullet: TextStyle(
                        color: mensagem.isUser ? Colors.white :
                            isDark ? Colors.white70 
                            : Colors.black87,
                      ),

                    ),
                    selectable: false,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${mensagem.timestamp.hour.toString().padLeft(2, '0')}:${mensagem.timestamp.minute.toString().padLeft(2, '0')}',
                    style: TextStyle(
                      color: mensagem.isUser
                          ? Colors.white70
                          : (isDark ? Colors.white54 
                          : Colors.black54),
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (mensagem.isUser) ...[
            const SizedBox(width: 8),
            CircleAvatar(
              backgroundColor: Colors.blue,
              child: const Icon(Icons.person, color: Colors.white, size: 20),
              radius: 16,
            ),
          ],
        ],
      ),
    );
  }
}