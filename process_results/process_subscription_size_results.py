import cbor2 as cbor2
import glob
from pathlib import Path
import json
import csv

def read_files(directory):
    if directory[-1] == "/": directory = directory[:-1]
    files = glob.glob(directory + "/**/*.json", recursive=True)
    sub_bench_results = {}
    for path in files:
        path_split = path.split("/")
        granularity = path_split[-1].split(".")[0].split("_")[1]
        with open(path, 'r') as f:
            if granularity not in sub_bench_results:
                sub_bench_results[granularity] = [json.load(f)]
            else:
                sub_bench_results[granularity].append(json.load(f))
    return sub_bench_results

def avg_sub_size(subscription):
    return sum([len(v) for v in subscription.values()]) / len(subscription.keys())

def num_events(subscription):
    return len(set([v for sub in subscription.values() for v in sub]))

def subbed_to_percentage(subscription):
    return avg_sub_size(subscription) / num_events(subscription)

def write_csv(out_path, filename, data):
    Path(out_path).mkdir(parents=True, exist_ok=True)
    full_path = out_path + filename if out_path[-1] == "/" or filename[0] == "/" else out_path + "/" + filename
    with open(full_path, 'w', newline='') as f:
        writer = csv.writer(f)
        writer.writerows(data)

def to_rows(points):
    data = [['number_of_edges', 'state_space_size', 'exact_efrac', 'overapproximated_efrac']]
    for k in sorted(points['Exact'].keys()):
        data.append([k, points['Exact'][k][0], points['Exact'][k][1], points['TwoStep'][k][1]])
    return data

def get_point_map(file):
    results = read_files(file)
    points = {}
    for (k, values) in results.items():
        points[k] = {}
        for v in values:
            points[k][v['number_of_edges']] = (v['state_space_size'], subbed_to_percentage(v['subscriptions']))
    return points

def subscription_results(input_data_directory, out_path, filename):
    write_csv(out_path, filename, to_rows(get_point_map(input_data_directory)))