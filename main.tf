resource "google_dialogflow_cx_agent" "agent" {
  display_name = "dialogflowcx-agent-1"
  location = "global"
  default_language_code = "en"
  supported_language_codes = ["fr","de","es"]
  time_zone = "America/New_York"
  description = "Example description."
  avatar_uri = "https://cloud.google.com/_static/images/cloud/icons/favicons/onecloud/super_cloud.png"
  enable_stackdriver_logging = true
  enable_spell_correction    = true
    speech_to_text_settings {
        enable_speech_adaptation = true
    }
}

resource "google_dialogflow_cx_agent" "agent_2" {
  display_name = "dialogflowcx-agent-2"
  location = "US"
  default_language_code = "en"
  supported_language_codes = ["fr","de","es"]
  time_zone = "America/New_York"
  description = "Example description."
  security_settings = 
  avatar_uri = "https://cloud.google.com/_static/images/cloud/icons/favicons/onecloud/super_cloud.png"
  enable_stackdriver_logging = true
  enable_spell_correction    = true
    speech_to_text_settings {
        enable_speech_adaptation = true
    }
}

resource "google_dialogflow_cx_entity_type" "basic_entity_type" {
  parent       = google_dialogflow_cx_agent.agent.id
  display_name = "MyEntity"
  kind         = "KIND_MAP"
  entities {
    value = "value1"
    synonyms = ["synonym1","synonym2"]
  }
  entities {
    value = "value2"
    synonyms = ["synonym3","synonym4"]
  }
  enable_fuzzy_extraction = false
}

resource "google_dialogflow_cx_version" "version_1" {
  parent       = google_dialogflow_cx_agent.agent.start_flow
  display_name = "1.0.0"
  description  = "version 1.0.0"
}

resource "google_dialogflow_cx_environment" "development" {
  parent       = google_dialogflow_cx_agent.agent.id
  display_name = "Development"
  description  = "Development Environment"
  version_configs {
    version = google_dialogflow_cx_version.version_1.id
  }
}

resource "google_dialogflow_cx_flow" "basic_flow" {
  parent       = google_dialogflow_cx_agent.agent.id
  display_name = "MyFlow"
  description  = "Test Flow"

  nlu_settings {
        classification_threshold = 0.3 
        model_type               = "MODEL_TYPE_STANDARD"
    }

  event_handlers {
           event                    = "custom-event"
           trigger_fulfillment {
                return_partial_responses = false
                messages {
                    text {
                        text  = ["I didn't get that. Can you say it again?"]
                    }
                }
            }
        }

        event_handlers {
            event                    = "sys.no-match-default"
            trigger_fulfillment {
                 return_partial_responses = false
                 messages {
                     text {
                         text  = ["Sorry, could you say that again?"]
                     }
                 }
             }
         }

         event_handlers {
            event                    = "sys.no-input-default"
            trigger_fulfillment {
                 return_partial_responses = false
                 messages {
                     text {
                         text  = ["One more time?"]
                     }
                 }
             }
         }
} 

resource "google_dialogflow_cx_intent" "basic_intent" {
  parent       = google_dialogflow_cx_agent.agent.id
  display_name = "Example"
  priority     = 1
  description  = "Intent example"
  training_phrases {
     parts {
         text = "training"
     }

     parts {
         text = "phrase"
     }

     parts {
         text = "example"
     }

     repeat_count = 1
  }

  parameters {
    id          = "param1"
    entity_type = "projects/-/locations/-/agents/-/entityTypes/sys.date"
  }

  labels  = {
      label1 = "value1",
      label2 = "value2"
   } 
}

resource "google_dialogflow_cx_page" "basic_page" {
  parent       = google_dialogflow_cx_agent.agent.start_flow
  display_name = "MyPage"

  entry_fulfillment {
        messages {
            text {
                text = ["Welcome to page"]
            }
        }
   }

   form {
        parameters {
            display_name = "param1"
            entity_type  = "projects/-/locations/-/agents/-/entityTypes/sys.date"
            fill_behavior {
                initial_prompt_fulfillment {
                    messages {
                        text {
                            text = ["Please provide param1"]
                        }
                    }
                }
            }
            required = "true"
            redact   = "true"
        }
    }

    transition_routes {
        condition = "$page.params.status = 'FINAL'"
        trigger_fulfillment {
            messages {
                text {
                    text = ["information completed, navigating to page 2"]
                }
            }
        }
        target_page = google_dialogflow_cx_page.my_page2.id
    }
} 

resource "google_dialogflow_cx_page" "my_page2" {
    parent       = google_dialogflow_cx_agent.agent.start_flow
    display_name  = "MyPage2"
}