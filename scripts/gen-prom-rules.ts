import { parseAllDocuments, stringify } from "yaml";
import { $ } from "bun";

const template = parseAllDocuments(await $`helm template prom prometheus-community/kube-prometheus-stack`.text());

const merged = {
    groups: []
};

template.forEach(doc => {
    const root = doc.toJS();
    const name = root.metadata.name;
    console.log(`Inspecting ${root.apiVersion}/${root.kind} ${name}`);
    if (root.apiVersion !== "monitoring.coreos.com/v1" || root.kind !== "PrometheusRule") {
        return;
    }
    console.log(`Updating with ${name}`);
    merged.groups = [...merged.groups, root.spec.groups];
});

await Bun.write("monitoring/mimir/recording-kubernetes.yaml", stringify(merged));
