FROM floydhub/pytorch:1.0.0-gpu.cuda9cudnn7-py3.37

ENV SCIKIT_LEARN_DATA /var/datasets/scikit_learn_data
ENV PYTHONPATH /opt/notebooks

WORKDIR /opt/notebooks

# is required by "cartopy"
# https://github.com/SciTools/cartopy/issues/1239
# "cartopy" is required by "contextily" to show tiles in "geopandas"
RUN apt-get update && apt-get install -y \
        libproj-dev \
  && apt-get clean \
  && apt-get autoremove \
  && rm -rf /var/cache/apt/archives/* \
  && rm -rf /var/lib/apt/lists/*

COPY requirements.txt /opt/notebooks/
RUN pip install --upgrade pip \
 && pip install --default-timeout=1000 --no-cache-dir -r requirements.txt

# FIXME:
# install all libs-my (which are under development)
ADD libs-my /opt/notebooks/libs-my
RUN pip install -e /opt/notebooks/libs-my/tfdatasets

# TODO:
# 1. maybe we should use some more general group and user name
# 2. has permission problem (PermissionError: [Errno 13] Permission denied: '/home/eugene')

#RUN groupadd -g 999 eugene && \
#    useradd -r -u 999 -g eugene eugene
#USER eugene

# return to this directory again
# WORKDIR /opt/notebooks
