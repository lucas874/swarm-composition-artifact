import glob
import json
from pathlib import Path
import cbor2 as cbor2
import csv

def read_files(directory):
    if directory[-1] == "/": directory = directory[:-1]
    files = glob.glob(directory + "/**/*.json", recursive=True)
    benchmark_inputs = {}
    for path in files:
        path_split = path.split("/")
        parent = "/".join(path_split[:-1])
        with open(path, 'r') as f:
            if parent not in benchmark_inputs:
                benchmark_inputs[parent] = [(path, json.load(f))]
            else:
                benchmark_inputs[parent].append((path, json.load(f)))
    return benchmark_inputs

def read_cbor(directory):
    if directory[-1]    == "/": directory = directory[:-1]
    files = glob.glob(directory + "/**/measurement_*.cbor", recursive=True)
    measurements = {}
    for file in files:
        main_index = file.split("/").index("main")
        with open(file, 'rb') as f:
            if file.split("/")[main_index + 2] not in measurements:
                measurements[file.split("/")[main_index + 2]] = [(int(file.split("/")[main_index + 3]), cbor2.load(f))]
            else:
                measurements[file.split("/")[main_index + 2]].append((int(file.split("/")[main_index + 3]), cbor2.load(f)))
    return measurements

def write_csv(out_path, filename, data):
    Path(out_path).mkdir(parents=True, exist_ok=True)
    full_path = out_path + filename if out_path[-1] == "/" or filename[0] == "/" else out_path + "/" + filename
    with open(full_path, 'w', newline='') as f:
        writer = csv.writer(f)
        writer.writerows(data)

def cbor_to_csv(experiment_results_directory, output_directory, filename):
    cbors = read_cbor(experiment_results_directory)
    benchmarks = read_files("../machines/machine-check/bench_and_results/benchmarks/general_pattern/")
    benches = dict()
    for k in benchmarks:
        for v in benchmarks[k]:
            benches[v[1]['state_space_size']] = v[1]['number_of_edges']

    results = {k: dict() for k in cbors.keys()}
    exact = 'Exact'
    overapproximated = 'Algorithm 1'

    for k in cbors.keys():
        for v in cbors[k]:
            results[k][benches[v[0]]] = (v[0], v[1]['estimates']['mean']['point_estimate'])
    edge_data = [['number_of_edges', 'state_space_size',  'exact_microseconds', 'overapproximated_microseconds']]
    for k in sorted(results[exact].keys()):
        edge_data.append([k, results[exact][k][0], results[exact][k][1] / (10**3), results[overapproximated][k][1] / (10**3)])

    write_csv(output_directory, filename, edge_data)