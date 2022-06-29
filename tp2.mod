# Parâmetros
# quantidade de empregados
param employees, >=1, integer;
# quantidade de dias do período
param days, >=1, integer;
# quantidade de turnos por dia
param shifts, >=1, integer;

# Sets
set E;
set D := {1..days};
set S := {1..shifts};
set K;
set R;
set E0;

# Tipo do trabalho obrigatoriamente (0: presencial, 1: remoto e 2: qualquer um)
param wr{E} in {0, 1, 2};

# Duração de um turno 
param t, >=1, integer;

# Carga horária do empregador
param h{E}, >= 1, integer;

# Máximo de horas que um empregado pode trabalhar no período
param mdh{E}, >= 1, integer;

# Número mínimo de empregados
param c{i in D, j in S, k in K}, >= 0, integer;

# Trabalho do empregado
param sk {i in E};

# Sala/escritório do empregado
param ar {i in E};

# Capacidade máxima do escritório
param cap {i in R};

# Disponibilidade para trabalhar
param w{i in E, j in D, k in S};

# Disponibilidade para trabalhar remotamente
param rw{i in E, j in D, k in S};

# Variáveis de decisão
# x: alocação trabalho presencial
#     = 1  se empregado E está alocado para trabalhar presencialmente no dia D e no turno S
#     = 0  se empregado E NÃO vai trabalhar presencialmente no dia D e no turno S
var x{i in E, j in D, k in S}, binary;
# y: alocação trabalho remoto
#     = 1  se empregado E está alocado para trabalhar remotamente no dia D e no turno S
#     = 0  se empregado E NÃO vai trabalhar remotamente no dia D e no turno S
var y{i in E, j in D, k in S}, binary;

# Função Objetiva
maximize x: sum{i in E, j in D, k in S} x[i, j, k];

# Restrições
# (3) Trabalho simultâneo
s.t. r_3{i in E, j in D, k in S}: x[i, j, k] + y[i, j, k] <= 1;
# (4) Empregados trabalhando apenas presencialmente
s.t. r_4{i in E, j in D, k in S}: if wr[i] = 0 then y[i, j, k] = 0;
# (5) Empregados trabalhando apenas remotamente
s.t. r_5{i in E, j in D, k in S}: if wr[i] = 1 then x[i, j, k] = 0;
# (6) Carga horária cumprida 
s.t. r_6{i in E}: sum{j in D, k in S} t * (x[i, j, k] + y[i, j, k]) = h[i];
# (7) Carga horária máxima diária não é ultrapassada
s.t. r_7{i in E, j in D}: sum{k in S} (t * (x[i, j, k] + y[i, j, k])) <= mdh[i];
# (8) Mão de obra mínima 
s.t. r_8{i in D, j in S, k in K}: sum{e in E: sk[e] = k} x[e, i, j] >= c[i, j, k];
# (9) Capacidade máxima da sala
s.t. r_9{i in D, j in S, r in R}: sum{e in E: ar[e] = r} x[e, i, j] <= cap[r];
# (10) Disponibilidade para trabalhar
s.t. r_10{i in E, j in D, k in S}: x[i, j, k] <= w[i, j, k];
# (11) Disponibilidade para trabalhar
s.t. r_11{i in E, j in D, k in S}: y[i, j, k] <= w[i, j, k];
# (12) Disponibilidade para trabalhar a distância
s.t. r_12{i in E, j in D, k in S}: y[i, j, k] <= rw[i, j, k];
# (13) Alternando empregados no período
s.t. r_13{i in E0, j in D, k in S}: if wr[i] = 2 then x[i, j, k] = 0;

solve;

end;








