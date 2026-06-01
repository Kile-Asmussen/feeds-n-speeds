use serde::Deserialize;
use std::collections::HashMap;

#[derive(Deserialize)]
struct PrototypeBase {
    #[serde(alias = "type")]
    type_name: PrototypeTypeId,
    name: String,
    order: Option<String>,
    localised_name: Option<LocalisedString>,
    localised_description: Option<LocalisedString>,
    factoripedia_description: Option<LocalisedString>,
    #[serde(default)]
    hidden: bool,
    hidden_in_factoripedia: Option<bool>,
    #[serde(default)]
    parameter: bool,
    factoripedia_simulation: Option<SimulationDefinition>,
}

#[derive(Deserialize)]
enum LocalisedString {
    #[serde(untagged)]
    String(String),
    #[serde(untagged)]
    Vec(Vec<LocalisedString>),
}

#[derive(Deserialize)]
#[serde(transparent)]
struct PrototypeTypeId(String);

#[derive(Deserialize)]
#[serde(transparent)]
struct ItemSubgroupId(String);

#[derive(Deserialize)]
#[serde(transparent)]
struct SimulationDefinition(HashMap<String, serde_json::Value>);

#[derive(Deserialize)]
struct Prototype {
    #[serde(flatten)]
    prototype_base: PrototypeBase,

    factoripedia_alternative: Option<String>,
    custom_tooltip_fields: Option<Vec<CustomTooltipField>>,
}

#[derive(Deserialize)]
struct CustomTooltipField {
    name: LocalisedString,
    value: LocalisedString,
    quality_header: Option<String>,
    quality_values: Option<HashMap<QualityId, LocalisedString>>,
    #[serde(default = "one_hundred")]
    order: u8,
    #[serde(default = "bool_true")]
    show_in_factoripedia: bool,
    #[serde(default = "bool_true")]
    show_in_tooltip: bool,
}

fn bool_true() -> bool {
    true
}

fn one_hundred() -> u8 {
    100
}

#[derive(Deserialize, Hash, PartialEq, Eq)]
#[serde(transparent)]
struct QualityId(String);
