# Project Organization

```
├── LICENSE
├── Makefile                <- Makefile with commands like `make data` or `make train`
├── README.md               <- The top-level README for developers using this project.
├── data
│   ├── interim             <- Intermediate data that has been transformed.
│   ├── processed           <- The final, canonical data sets for modeling.
│   └── raw                 <- The original, immutable data dump.
│
├── docs                    <- A default Sphinx project; see sphinx-doc.org for details
│   └── Problem Statement
|
├── figures                 <- All EDA and model saved images
|
├── models                  <- Trained and serialized models, model predictions, or model summaries
│   └── RandomForestModel   <- Generated graphics and figures to be used in reporting
|
├── notebooks                <- Jupyter notebooks. Naming convention is a number (for ordering),
│   ├── 1. Quora Insincere Capstone Data Wrangling.ipynb
│   ├── 2. EDA_Quora Insincere Capstone Data.ipynb
│   ├── 3. Preprocessing and Training Data Development.ipynb
│   └── 4. Quora Insincere Classification - Modeling Step.ipynb                                       
│
├── references         <- Data dictionaries, manuals, and all other explanatory materials.
│   └── references.txt <- All project references - stackoverflow urls etc.
│
├── reports            <- Generated analysis as HTML, PDF, LaTeX, etc.
│   ├── Capstone_Presentation.pptx                       <- Final presentation
│   └── Final_Rep_Quora_Insincere_Classification.docx    <- Final report
│
├── requirements.txt   <- The requirements file for reproducing the analysis environment, e.g.
│                         generated with `pip freeze > requirements.txt`
│
├── setup.py           <- Make this project pip installable with `pip install -e`
├──  src                <- Source code for use in this project.
|    └── data           <- Scripts to download or generate data
|       └── make_dataset.py
│
└── tox.ini            <- tox file with settings for running tox; see tox.testrun.org
```

# Description
https://www.kaggle.com/c/quora-insincere-questions-classification

**Problem**
An existential problem for any major website today is how to handle toxic and divisive content. Quora wants to tackle this problem head-on to keep their platform a place where users can feel safe sharing their knowledge with the world.

**Tasks**
- Perform Data Wrangling on the merged traiing and test dataframe
    - Data Collection
    - Data Organization
    - Data Definition
    - Data Cleaning  
-	Develop scalable methods to detect toxic and misleading content like:
    - Non neutral tone
    - Disparaging tone
    - False information
    - Absurd assumptions
    - Sexual content
-	Weed out insincere questions -- those founded upon false premises, or that intend to make a statement rather than look for helpful answers.

**Data used**
Data files contain
-	Training and testing data set where training data set contains quora questionId’s with insincere content marked by value = 1, otherwise 0
-	Number of word embeddings along with the dataset that can be used in the models
The file is a matrix of about 376 thousand observations and 7 variables.

**Steps performed**
- **Data Wrangling** - Extraction, cleaning of text data by removing punctuations, NaN, used functions like Stemming, Tokenization, Vectorization etc.
- **Exploratory Data Analysis (EDA)** -  for seeing co-relation of features in the Quora data set, created unigrams, bigrams, word cloud and 3d scatter plots for this purpose
- **Feature Engineering** (Pre-processing and training data development) - Performed numeric variable scaling, TFIDF vectorization to generate categorical variables as features to generate an updated feature engineered dataset. Thereafter broke the dataset into training and test data set
        - After the above steps, the data was condensed into 102K observations which is further broken down into training and testing data set containing 506 features created by count vectorization of 'question_text' column
- **Modeling**  - See details below

**Models applied**
This is a classification problem, in supervised learning. Here I have applied the following classification models:
- Logistic Regression
       - Normal
       - With L2 regularization
- Naive Bayes
- Decision Trees
- Random Forest
- Gradient Boost

**Model Evaluation**
- Used metrics like Precision, Accuracy, Recall, f1 score, ROC AUC score to evaluate model performance.
- Built confusion matrix to see false positives and false negatives after running each model against the training dataset and computing predictions against validation dataset.
- f1 weighted score and ROC AUC score were used as primary metrics for determining best performing models.

**Hyperparameter tuning and model optimization**
- Additionally, hyperparameter tuning was done on the best performing shortlisted model(s) to enhance performance.
- Also, Cross validation using Grid search was applied to pick up random pairs of training and validation data by splitting the training set into k smaller sets, where a model is trained using k-1 of the folds as training data and the model is validated on the remaining part.

**Save and load model for future data prediction**
- Eventually, model was saved for future application.

**Unseen test data prediction**
- Saved model was loaded and applied to the unseen test dataset
- Used classification metrics to calculate scores to validate the effectiveness of model on unseen data prediction.
