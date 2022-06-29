# Parameters
# Number of employees
param employees, >=1, integer;
# Number of days over the planning period
param days, >=1, integer;
# Number of shifts per day
param shifts, >=1, integer;

# Sets
set E;
set D := {1..days};
set S := {1..shifts};
set K;
set R;
set E0;

# Type of work (0: on site, 1: remote e 2: both)
param wr{E} in {0, 1, 2};

# Duration of a shift 
param t, >=1, integer;

# Employee's workload
param h{E}, >= 1, integer;

# Maximum number of hours an employee can work on site during the day
param mdh{E}, >= 1, integer;

# Minimum number of employees
param c{i in D, j in S, k in K}, >= 0, integer;

# Employee's work
param sk {i in E};

# Employee's room or office
param ar {i in E};

# Maximum office capacity
param cap {i in R};

# Availability to work
param w{i in E, j in D, k in S};

# Availability to work remotely
param rw{i in E, j in D, k in S};

# Decision variables
# x: work allocation
#     = 1  if employee E is set to work on site on the day D and shift S
#     = 0  if employee E is not set to work on site on the day D and shift 
var x{i in E, j in D, k in S}, binary;
# y: remote work allocation
#     = 1  if employee E is set to work remotely on the day D and shift S
#     = 0  if employee E is not set to work remotely on the day D and shift S
var y{i in E, j in D, k in S}, binary;

# Objective function
maximize x: sum{i in E, j in D, k in S} x[i, j, k];

# Restrictions
# (3) Working simultaneously
s.t. r_3{i in E, j in D, k in S}: x[i, j, k] + y[i, j, k] <= 1;
# (4) Employees working only on site
s.t. r_4{i in E, j in D, k in S}: if wr[i] = 0 then y[i, j, k] = 0;
# (5) Employees working only remotely
s.t. r_5{i in E, j in D, k in S}: if wr[i] = 1 then x[i, j, k] = 0;
# (6) Workload fulfilled
s.t. r_6{i in E}: sum{j in D, k in S} t * (x[i, j, k] + y[i, j, k]) = h[i];
# (7) Maximum daily workload is not exceeded
s.t. r_7{i in E, j in D}: sum{k in S} (t * (x[i, j, k] + y[i, j, k])) <= mdh[i];
# (8) Minimum number of employees
s.t. r_8{i in D, j in S, k in K}: sum{e in E: sk[e] = k} x[e, i, j] >= c[i, j, k];
# (9) Maximum office capacity
s.t. r_9{i in D, j in S, r in R}: sum{e in E: ar[e] = r} x[e, i, j] <= cap[r];
# (10) Availability to work
s.t. r_10{i in E, j in D, k in S}: x[i, j, k] <= w[i, j, k];
# (11) Availability to work
s.t. r_11{i in E, j in D, k in S}: y[i, j, k] <= w[i, j, k];
# (12) Availability to work remotely
s.t. r_12{i in E, j in D, k in S}: y[i, j, k] <= rw[i, j, k];
# (13) Alternating employees
s.t. r_13{i in E0, j in D, k in S}: if wr[i] = 2 then x[i, j, k] = 0;

solve;

end;








