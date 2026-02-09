import cbor2 as cbor2
import glob
from pathlib import Path
import json
import csv
import seaborn as sns
import pandas as pd
import matplotlib.pyplot as plt
import sys
import argparse

def read_files(directory):
    if directory[-1] == "/": directory = directory[:-1]
    files = glob.glob(directory + "/**/*.json", recursive=True)
    sub_bench_results = {}
    for path in files:
        with open(path, 'r') as f:
            bench_output = json.load(f)
            if bench_output["version"] not in sub_bench_results:
                sub_bench_results[bench_output["version"]] = [bench_output]
            else:
                sub_bench_results[bench_output["version"]].append(bench_output)
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
    data = [['id', 'number_of_edges', 'state_space_size', 'KMT_23_efrac', 'compositional_exact_efrac', 'compositional_alg1_efrac']]
    for k in sorted(points['KMT23'].keys()):
        kmt_entry = points['KMT23'][k]
        compositional_exact_entry = points['CompositionalExact'][k]
        compositional_alg1_entry = points['CompositionalOverapprox'][k]
        assert(kmt_entry['number_of_edges'] == compositional_exact_entry['number_of_edges'])
        assert(kmt_entry['state_space_size'] == compositional_exact_entry['state_space_size'])
        assert(kmt_entry['number_of_edges'] == compositional_alg1_entry['number_of_edges'])
        assert(kmt_entry['state_space_size'] == compositional_alg1_entry['state_space_size'])
        data.append([k, kmt_entry['number_of_edges'], kmt_entry['state_space_size'], kmt_entry['efrac'], compositional_exact_entry['efrac'], compositional_alg1_entry['efrac']])
    return data

def get_point_map(file):
    results = read_files(file)
    points = {}

    for (k, values) in results.items():
        points[k] = {}
        for v in values:
            points[k][v['id']] = { 'number_of_edges': v['number_of_edges'], 'state_space_size': v['state_space_size'], 'efrac': subbed_to_percentage(v['subscriptions']) }
    return points

def subscription_results(input_data_directory, out_path, filename):
    write_csv(out_path, filename, to_rows(get_point_map(input_data_directory)))


def boxplot(subscription_size_csv, out_filename):
    subscription_sizes = pd.read_csv(subscription_size_csv)
    subscription_sizes.rename(columns={"KMT_23_efrac": "KMT23", "compositional_exact_efrac": "Exact", "compositional_alg1_efrac": "Algorithm 1"}, inplace=True)
    subscription_sizes = subscription_sizes.melt(id_vars=["id", "number_of_edges", "state_space_size"])
    sns.set_theme()
    sns.set_style("whitegrid")
    fig, ax =plt.subplots(figsize=(8, 10))
    plot2 = sns.boxplot(x="variable", y="value", data=subscription_sizes, hue="variable", palette=['r', 'b', 'g'], showmeans=True)
    plot2.set(xlabel="", ylabel="Efrac")
    plt.savefig(out_filename, format="pdf", dpi=600, bbox_inches="tight")


def main():
    parser = argparse.ArgumentParser(description="Turn subscription size experiment results in to csvs")
    parser.add_argument('-a', '--accuracy', type=str, help='Directory containing subscription size results')
    parser.add_argument('-o', '--output_directory', type=str, help='Directory to store plots and csvs')
    parser.add_argument('-c', '--csv_filename', type=str, help='Filename of generated csv (placed under output directory)')
    args = parser.parse_args()

    if not args.accuracy:
        parser.print_help()
        sys.exit(1)

    subscription_results(args.accuracy, args.output_directory, f"{args.csv_filename}")

    output_pdf_filename = f"{args.output_directory}/compositional_vs_ecoop23.pdf"
    boxplot(f"{args.output_directory}/{args.csv_filename}", output_pdf_filename)

if __name__ == "__main__":
    main()