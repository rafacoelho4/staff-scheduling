# Par�metros
# quantidade de empregados
param employees, >=1, integer;
# quantidade de dias do per�odo
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

# Dura��o de um turno 
param t, >=1, integer;

# Carga hor�ria do empregador
param h{E}, >= 1, integer;

# M�ximo de horas que um empregado pode trabalhar no per�odo
param mdh{E}, >= 1, integer;

# N�mero m�nimo de empregados
param c{i in D, j in S, k in K}, >= 0, integer;

# Trabalho do empregado
param sk {i in E};

# Sala/escrit�rio do empregado
param ar {i in E};

# Capacidade m�xima do escrit�rio
param cap {i in R};

# Disponibilidade para trabalhar
param w{i in E, j in D, k in S};

# Disponibilidade para trabalhar remotamente
param rw{i in E, j in D, k in S};

# Vari�veis de decis�o
# x: aloca��o trabalho presencial
#     = 1  se empregado E est� alocado para trabalhar presencialmente no dia D e no turno S
#     = 0  se empregado E N�O vai trabalhar presencialmente no dia D e no turno S
var x{i in E, j in D, k in S}, binary;
# y: aloca��o trabalho remoto
#     = 1  se empregado E est� alocado para trabalhar remotamente no dia D e no turno S
#     = 0  se empregado E N�O vai trabalhar remotamente no dia D e no turno S
var y{i in E, j in D, k in S}, binary;

# Fun��o Objetiva
maximize x: sum{i in E, j in D, k in S} x[i, j, k];

# Restri��es
# (3) Trabalho simult�neo
s.t. r_3{i in E, j in D, k in S}: x[i, j, k] + y[i, j, k] <= 1;
# (4) Empregados trabalhando apenas presencialmente
s.t. r_4{i in E, j in D, k in S}: if wr[i] = 0 then y[i, j, k] = 0;
# (5) Empregados trabalhando apenas remotamente
s.t. r_5{i in E, j in D, k in S}: if wr[i] = 1 then x[i, j, k] = 0;
# (6) Carga hor�ria cumprida 
s.t. r_6{i in E}: sum{j in D, k in S} t * (x[i, j, k] + y[i, j, k]) = h[i];
# (7) Carga hor�ria m�xima di�ria n�o � ultrapassada
s.t. r_7{i in E, j in D}: sum{k in S} (t * (x[i, j, k] + y[i, j, k])) <= mdh[i];
# (8) M�o de obra m�nima 
s.t. r_8{i in D, j in S, k in K}: sum{e in E: sk[e] = k} x[e, i, j] >= c[i, j, k];
# (9) Capacidade m�xima da sala
s.t. r_9{i in D, j in S, r in R}: sum{e in E: ar[e] = r} x[e, i, j] <= cap[r];
# (10) Disponibilidade para trabalhar
s.t. r_10{i in E, j in D, k in S}: x[i, j, k] <= w[i, j, k];
# (11) Disponibilidade para trabalhar
s.t. r_11{i in E, j in D, k in S}: y[i, j, k] <= w[i, j, k];
# (12) Disponibilidade para trabalhar a dist�ncia
s.t. r_12{i in E, j in D, k in S}: y[i, j, k] <= rw[i, j, k];
# (13) Alternando empregados no per�odo
s.t. r_13{i in E0, j in D, k in S}: if wr[i] = 2 then x[i, j, k] = 0;

solve;

end;








