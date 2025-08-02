# attack_component.gd
class_name AttackComponent
extends Node

signal attack_finished

@export var attacks: Array[BossAttack]

# Certifique-se de que este nó Timer exista como filho do AttackComponent na cena.
@onready var attack_timer: Timer = $AttackTimer
@onready var host = owner

var attacking: bool = false
var current_attack: BossAttack

func _ready():
	# --- DEPURACAO ---
	# Avisa no início se nenhum ataque foi configurado no Inspetor.
	if attacks.is_empty():
		print("AVISO DE DEPURACAO: O array 'attacks' do AttackComponent está vazio. Adicione recursos de ataque no Inspetor.")
	# -----------------
	
	# Conectamos o sinal de timeout do timer à nossa função.
	attack_timer.timeout.connect(_on_attack_timer_timeout)

func perform_attack():
	# --- DEPURACAO ---
	print("DEPURACAO: perform_attack() foi chamado. Flag 'attacking': %s" % attacking)
	# -----------------

	if attacking or attacks.is_empty():
		# --- DEPURACAO ---
		print("DEPURACAO: perform_attack() retornou porque 'attacking' é true ou o array 'attacks' está vazio.")
		# -----------------
		return
	
	attacking = true
	current_attack = attacks.pick_random()
	
	# Verifica se o recurso de ataque foi carregado corretamente.
	if not current_attack:
		print("ERRO: Tentativa de realizar um ataque nulo. Verifique se há entradas vazias no array de ataques.")
		attacking = false
		return

	# --- DEPURACAO ---
	print("DEPURACAO: Ataque escolhido: '%s'. Duração: %s segundos." % [current_attack.resource_path, current_attack.attack_duration])
	# -----------------

	# Define o tempo de espera do Timer com base na duração definida no nosso recurso de ataque.
	attack_timer.wait_time = current_attack.attack_duration
	attack_timer.start()
	
	# --- DEPURACAO ---
	print("DEPURACAO: Timer de ataque iniciado com wait_time de %s." % attack_timer.wait_time)
	# -----------------
	
	# Executa a lógica do ataque (que pode incluir tocar uma animação).
	current_attack.execute(host, self)

# Chamado quando o Timer termina a contagem.
func _on_attack_timer_timeout():
	# --- DEPURACAO ---
	print("DEPURACAO: _on_attack_timer_timeout() foi chamado.")
	# -----------------

	# Verificamos se ainda estamos no estado de ataque para evitar sinais duplicados.
	if attacking:
		print("DEPURACAO: Fim do ataque. Resetando flag 'attacking' e emitindo 'attack_finished'.")
		attacking = false
		attack_finished.emit()
	else:
		print("DEPURACAO: _on_attack_timer_timeout() chamado, mas 'attacking' já era false.")


# Permite que o chefe force o fim do estado de ataque (ex: ao receber stun).
func finish_attack_manually():
	if not attacking: return
	
	print("DEPURACAO: finish_attack_manually() chamado.")
	attack_timer.stop()
	# Chama a mesma lógica do timeout para centralizar o comportamento de finalização.
	_on_attack_timer_timeout()

func stop_attack_timer():
	attack_timer.stop()

'''

### O que procurar na Saída:

1.  **`AVISO DE DEPURACAO: O array 'attacks' do AttackComponent está vazio.`**
	* **Problema:** Você não adicionou nenhum recurso de ataque (`.tres`) ao array `attacks` no Inspetor do Godot.
	* **Solução:** Selecione o nó `AttackComponent` do seu Boss. No Inspetor, encontre a propriedade "Attacks". Aumente o tamanho do array para 1 (ou mais) e arraste o seu ficheiro `SimpleMeleeAttack.tres` para o novo campo que apareceu.

2.  **`DEPURACAO: perform_attack() retornou porque 'attacking' é true ou o array 'attacks' está vazio.`**
	* **Problema:** O código está a tentar atacar, mas ou o array está vazio (ver ponto 1) ou a flag `attacking` não foi resetada corretamente de um ataque anterior.
	* **Solução:** Se o array não estiver vazio, significa que a flag `attacking` está presa em `true`. Verifique se o sinal `attack_finished` está a ser emitido e recebido corretamente pelo `AttackState`.

3.  **Se você vir `DEPURACAO: perform_attack() foi chamado.` mas mais nada a seguir:**
	* **Problema:** O código está a passar a verificação inicial, mas algo está a falhar ao escolher ou executar o ataque. Verifique se há uma mensagem de `ERRO` sobre um ataque nulo.
	* **Solução:** Certifique-se de que não há entradas vazias (null) no seu array de ataques no Inspetor.

Ao analisar estas mensagens, você deverá conseguir identificar a causa exata do proble
'''
