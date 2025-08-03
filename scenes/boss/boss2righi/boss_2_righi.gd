# boss_2_righi.gd
extends Boss

# Este script agora pode ficar vazio ou ser removido se não houver
# nenhuma outra lógica específica para este boss.

# Ao remover a função _physics_process daqui, garantimos que ele usará
# a função _physics_process da classe pai (Boss), evitando conflitos
# de lógica de movimento. O comportamento do ataque (parar, dar dash)
# será controlado pelo AttackComponent e pelo AttackState, que é
# o lugar correto para essa lógica.
pass
