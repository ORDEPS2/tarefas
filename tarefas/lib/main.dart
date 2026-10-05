import 'package:flutter/material.dart';

void main() {
runApp(const MeuApp());
}

class Tarefa {
int id;
String titulo;
String descricao;
StatusTarefa status;

Tarefa({
required this.id,
required this.titulo,
required this.descricao,
this.status = StatusTarefa.nova,
});
}

enum StatusTarefa {
nova,
andamento,
concluida,
}

class MeuApp extends StatelessWidget {
const MeuApp({super.key});

@override
Widget build(BuildContext context) {
return MaterialApp(
debugShowCheckedModeBanner: false,
title: 'Minhas Tarefas',
theme: ThemeData(
useMaterial3: true,
scaffoldBackgroundColor: const Color(0xFF0D0A14),
colorScheme: ColorScheme.fromSeed(
seedColor: const Color(0xFF8B5CF6),
brightness: Brightness.dark,
),
),
home: const TelaTarefas(),
);
}
}

class TelaTarefas extends StatefulWidget {
const TelaTarefas({super.key});

@override
State<TelaTarefas> createState() => _TelaTarefasState();
}

class _TelaTarefasState extends State<TelaTarefas> {
final List<Tarefa> tarefas = [
Tarefa(
id: 1,
titulo: 'Estudar Flutter',
descricao: 'Revisar POO e desenvolvimento de aplicativos.',
status: StatusTarefa.andamento,
),
Tarefa(
id: 2,
titulo: 'Fazer atividade do SENAI',
descricao: 'Finalizar o aplicativo de tarefas.',
status: StatusTarefa.nova,
),
Tarefa(
id: 3,
titulo: 'Organizar materiais',
descricao: 'Separar os materiais para a aula.',
status: StatusTarefa.concluida,
),
];

String filtro = 'Todas';
String pesquisa = '';

int get novas =>
tarefas.where((t) => t.status == StatusTarefa.nova).length;

int get andamento =>
tarefas.where((t) => t.status == StatusTarefa.andamento).length;

int get concluidas =>
tarefas.where((t) => t.status == StatusTarefa.concluida).length;

List<Tarefa> get tarefasFiltradas {
List<Tarefa> resultado = tarefas;

if (filtro == 'Novas') {
resultado =
resultado.where((t) => t.status == StatusTarefa.nova).toList();
}

if (filtro == 'Andamento') {
resultado =
resultado.where((t) => t.status == StatusTarefa.andamento).toList();
}

if (filtro == 'Concluídas') {
resultado =
resultado.where((t) => t.status == StatusTarefa.concluida).toList();
}

if (pesquisa.isNotEmpty) {
resultado = resultado
    .where(
(t) =>
t.titulo.toLowerCase().contains(pesquisa.toLowerCase()) ||
t.descricao.toLowerCase().contains(pesquisa.toLowerCase()),
)
    .toList();
}

return resultado;
}

void adicionarTarefa() {
final tituloController = TextEditingController();
final descricaoController = TextEditingController();

showDialog(
context: context,
builder: (context) {
return AlertDialog(
backgroundColor: const Color(0xFF18121F),
title: const Text(
'Nova tarefa',
style: TextStyle(color: Colors.white),
),
content: Column(
mainAxisSize: MainAxisSize.min,
children: [
TextField(
controller: tituloController,
style: const TextStyle(color: Colors.white),
decoration: campo('Título'),
),
const SizedBox(height: 15),
TextField(
controller: descricaoController,
style: const TextStyle(color: Colors.white),
maxLines: 3,
decoration: campo('Descrição'),
),
],
),
actions: [
TextButton(
onPressed: () => Navigator.pop(context),
child: const Text(
'Cancelar',
style: TextStyle(color: Colors.white70),
),
),
TextButton(
onPressed: () {
if (tituloController.text.trim().isEmpty) {
return;
}

setState(() {
tarefas.add(
Tarefa(
id: DateTime.now().millisecondsSinceEpoch,
titulo: tituloController.text.trim(),
descricao: descricaoController.text.trim(),
),
);
});

Navigator.pop(context);
},
child: const Text(
'Adicionar',
style: TextStyle(
color: Color(0xFFA78BFA),
fontWeight: FontWeight.bold,
),
),
),
],
);
},
);
}

void editarTarefa(Tarefa tarefa) {
final tituloController =
TextEditingController(text: tarefa.titulo);

final descricaoController =
TextEditingController(text: tarefa.descricao);

showDialog(
context: context,
builder: (context) {
return AlertDialog(
backgroundColor: const Color(0xFF18121F),
title: const Text(
'Editar tarefa',
style: TextStyle(
color: Colors.white,
fontWeight: FontWeight.bold,
),
),
content: Column(
mainAxisSize: MainAxisSize.min,
children: [
TextField(
controller: tituloController,
style: const TextStyle(color: Colors.white),
decoration: campo('Título'),
),
const SizedBox(height: 15),
TextField(
controller: descricaoController,
style: const TextStyle(color: Colors.white),
maxLines: 3,
decoration: campo('Descrição'),
),
],
),
actions: [
TextButton(
onPressed: () {
Navigator.pop(context);
},
child: const Text(
'Cancelar',
style: TextStyle(color: Colors.white70),
),
),
TextButton(
onPressed: () {
if (tituloController.text.trim().isEmpty) {
return;
}

setState(() {
tarefa.titulo = tituloController.text.trim();
tarefa.descricao =
descricaoController.text.trim();
});

Navigator.pop(context);
},
child: const Text(
'Salvar',
style: TextStyle(
color: Color(0xFFA78BFA),
fontWeight: FontWeight.bold,
),
),
),
],
);
},
);
}

InputDecoration campo(String texto) {
return InputDecoration(
labelText: texto,
labelStyle: const TextStyle(color: Colors.white70),
filled: true,
fillColor: const Color(0xFF241A30),
border: OutlineInputBorder(
borderRadius: BorderRadius.circular(12),
borderSide: BorderSide.none,
),
focusedBorder: OutlineInputBorder(
borderRadius: BorderRadius.circular(12),
borderSide: const BorderSide(
color: Color(0xFFA78BFA),
),
),
);
}

void alterarStatus(Tarefa tarefa) {
setState(() {
if (tarefa.status == StatusTarefa.nova) {
tarefa.status = StatusTarefa.andamento;
} else if (tarefa.status == StatusTarefa.andamento) {
tarefa.status = StatusTarefa.concluida;
} else {
tarefa.status = StatusTarefa.nova;
}
});
}

void excluirTarefa(Tarefa tarefa) {
setState(() {
tarefas.remove(tarefa);
});
}

Color corStatus(StatusTarefa status) {
switch (status) {
case StatusTarefa.nova:
return const Color(0xFF8B5CF6);
case StatusTarefa.andamento:
return const Color(0xFFA78BFA);
case StatusTarefa.concluida:
return const Color(0xFFC4B5FD);
}
}

String nomeStatus(StatusTarefa status) {
switch (status) {
case StatusTarefa.nova:
return 'Nova';
case StatusTarefa.andamento:
return 'Em andamento';
case StatusTarefa.concluida:
return 'Concluída';
}
}

IconData iconeStatus(StatusTarefa status) {
switch (status) {
case StatusTarefa.nova:
return Icons.fiber_new;
case StatusTarefa.andamento:
return Icons.timelapse;
case StatusTarefa.concluida:
return Icons.check_circle;
}
}

Widget botaoFiltro(
String texto,
int quantidade,
IconData icone,
String valorFiltro,
) {
final selecionado = filtro == valorFiltro;

return Expanded(
child: GestureDetector(
onTap: () {
setState(() {
filtro = valorFiltro;
});
},
child: AnimatedContainer(
duration: const Duration(milliseconds: 200),
padding: const EdgeInsets.symmetric(
vertical: 14,
horizontal: 8,
),
decoration: BoxDecoration(
color: selecionado
? const Color(0xFF7C3AED)
    : const Color(0xFF19121F),
borderRadius: BorderRadius.circular(16),
border: Border.all(
color: selecionado
? const Color(0xFFA78BFA)
    : const Color(0xFF30223D),
),
),
child: Column(
children: [
Icon(
icone,
color: selecionado
? Colors.white
    : const Color(0xFFA78BFA),
size: 23,
),
const SizedBox(height: 7),
Text(
texto,
textAlign: TextAlign.center,
style: TextStyle(
color: selecionado
? Colors.white
    : Colors.white70,
fontSize: 12,
fontWeight: FontWeight.bold,
),
),
const SizedBox(height: 3),
Text(
quantidade.toString(),
style: TextStyle(
color: selecionado
? Colors.white
    : const Color(0xFFA78BFA),
fontSize: 17,
fontWeight: FontWeight.bold,
),
),
],
),
),
),
);
}

Widget cardTarefa(Tarefa tarefa) {
final cor = corStatus(tarefa.status);

return Container(
margin: const EdgeInsets.only(bottom: 14),
decoration: BoxDecoration(
color: const Color(0xFF17111E),
borderRadius: BorderRadius.circular(20),
border: Border.all(
color: cor.withOpacity(0.35),
),
),
child: Padding(
padding: const EdgeInsets.all(18),
child: Row(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
GestureDetector(
onTap: () => alterarStatus(tarefa),
child: Container(
width: 45,
height: 45,
decoration: BoxDecoration(
color: cor.withOpacity(0.15),
borderRadius: BorderRadius.circular(14),
),
child: Icon(
iconeStatus(tarefa.status),
color: cor,
size: 25,
),
),
),
const SizedBox(width: 14),
Expanded(
child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
Text(
tarefa.titulo,
style: TextStyle(
color: Colors.white,
fontSize: 17,
fontWeight: FontWeight.bold,
decoration:
tarefa.status == StatusTarefa.concluida
? TextDecoration.lineThrough
    : TextDecoration.none,
),
),
const SizedBox(height: 6),
Text(
tarefa.descricao,
style: const TextStyle(
color: Colors.white60,
fontSize: 13,
height: 1.4,
),
),
const SizedBox(height: 12),
Container(
padding: const EdgeInsets.symmetric(
horizontal: 10,
vertical: 5,
),
decoration: BoxDecoration(
color: cor.withOpacity(0.12),
borderRadius: BorderRadius.circular(20),
),
child: Text(
nomeStatus(tarefa.status),
style: TextStyle(
color: cor,
fontSize: 11,
fontWeight: FontWeight.bold,
),
),
),
],
),
),
const SizedBox(width: 8),
Column(
children: [
GestureDetector(
onTap: () => editarTarefa(tarefa),
child: Container(
padding: const EdgeInsets.all(7),
decoration: BoxDecoration(
color: const Color(0xFF241A30),
borderRadius: BorderRadius.circular(10),
),
child: const Icon(
Icons.edit_outlined,
color: Color(0xFFA78BFA),
size: 20,
),
),
),
const SizedBox(height: 8),
GestureDetector(
onTap: () => excluirTarefa(tarefa),
child: Container(
padding: const EdgeInsets.all(7),
decoration: BoxDecoration(
color: const Color(0xFF241A30),
borderRadius: BorderRadius.circular(10),
),
child: const Icon(
Icons.delete_outline,
color: Colors.white38,
size: 20,
),
),
),
],
),
],
),
),
);
}

@override
Widget build(BuildContext context) {
return Scaffold(
backgroundColor: const Color(0xFF0D0A14),
floatingActionButton: FloatingActionButton(
onPressed: adicionarTarefa,
backgroundColor: const Color(0xFF8B5CF6),
child: const Icon(
Icons.add,
color: Colors.white,
),
),
body: SafeArea(
child: Column(
children: [
Padding(
padding: const EdgeInsets.fromLTRB(20, 25, 20, 10),
child: Row(
children: [
Container(
width: 48,
height: 48,
decoration: BoxDecoration(
gradient: const LinearGradient(
colors: [
Color(0xFF7C3AED),
Color(0xFFA78BFA),
],
),
borderRadius: BorderRadius.circular(15),
),
child: const Icon(
Icons.checklist_rounded,
color: Colors.white,
size: 28,
),
),
const SizedBox(width: 14),
const Expanded(
child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
Text(
'Minhas tarefas',
style: TextStyle(
color: Colors.white,
fontSize: 25,
fontWeight: FontWeight.bold,
),
),
SizedBox(height: 3),
Text(
'Organize seu dia',
style: TextStyle(
color: Colors.white54,
fontSize: 13,
),
),
],
),
),
],
),
),
Padding(
padding: const EdgeInsets.symmetric(
horizontal: 20,
vertical: 10,
),
child: TextField(
onChanged: (valor) {
setState(() {
pesquisa = valor;
});
},
style: const TextStyle(color: Colors.white),
decoration: InputDecoration(
hintText: 'Pesquisar tarefas...',
hintStyle: const TextStyle(
color: Colors.white38,
),
prefixIcon: const Icon(
Icons.search,
color: Color(0xFFA78BFA),
),
filled: true,
fillColor: const Color(0xFF17111E),
border: OutlineInputBorder(
borderRadius: BorderRadius.circular(16),
borderSide: BorderSide.none,
),
),
),
),
Padding(
padding: const EdgeInsets.fromLTRB(20, 8, 20, 15),
child: Row(
children: [
botaoFiltro(
'Novas',
novas,
Icons.fiber_new,
'Novas',
),
const SizedBox(width: 8),
botaoFiltro(
'Andamento',
andamento,
Icons.timelapse,
'Andamento',
),
const SizedBox(width: 8),
botaoFiltro(
'Concluídas',
concluidas,
Icons.check_circle_outline,
'Concluídas',
),
],
),
),
Expanded(
child: tarefasFiltradas.isEmpty
? const Center(
child: Column(
mainAxisAlignment: MainAxisAlignment.center,
children: [
Icon(
Icons.task_alt,
color: Color(0xFFA78BFA),
size: 60,
),
SizedBox(height: 15),
Text(
'Nenhuma tarefa encontrada',
style: TextStyle(
color: Colors.white70,
fontSize: 16,
),
),
],
),
)
    : ListView.builder(
padding: const EdgeInsets.fromLTRB(
20,
5,
20,
90,
),
itemCount: tarefasFiltradas.length,
itemBuilder: (context, index) {
return cardTarefa(
tarefasFiltradas[index],
);
},
),
),
],
),
),
);
}
}
