% Add the InfluxDB library
addpath(genpath('./influxdb-client'));
% Init client
URL = 'INSERT URL';
USER = '';
PASS = '';
DATABASE = 'INSERT DATABASE NAME';
influxdb = InfluxDB(URL, USER, PASS, DATABASE);
% Test the connection
[ok, millis] = influxdb.ping();
assert(ok, 'InfluxDB is DOWN!');
fprintf('InfluxDB is OK (%.2fms)\n\n', millis);
%% Data reading
str = 'SELECT * FROM <MEASUREMENT NAME> WHERE time > now() - 1m';
result_query = influxdb.runQuery(str);
query = result_query.series('INSERT MEASUREMENT NAME');
TSP = query.time;
data = query.table();
% Assign one variable to each column 
signal_1 = [data.kurtosis];
signal_2 = [data.mean];
signal_3 = [data.rms];
signal_4 = [data.skewness];
signal_5 = [data.square];
m1 = mean(signal_1);
m2 = mean(signal_2);
m3 = mean(signal_3);
m4 = mean(signal_4);
m5 = mean(signal_5);
%%
% Prepare the data
result_post = Series('Resultados')...
 . fields('Result_kurtosis', m1) ...
 . fields('Result_mean', m2) ...
 . fields('Result_rms', m3) ...
 . fields('Result_skewness', m4) ...
 . fields('Result_square', m5);

% Build preview
influxdb.writer() ...
 .append(result_post)...
 .build()

% Post
influxdb.writer() ...
 .append(result_post)...
 .execute();