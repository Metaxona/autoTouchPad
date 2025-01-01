
USER=$(shell whoami)

SERVICE_FILE_NAME=toggleTouchPad.service
SCRIPT_FILE_NAME=toggleTouchPad.sh
LOG_FILE_NAME=service.log

SERVICE_LOCATION=/home/${USER}/.config/systemd/user
SCRIPT_LOCATION=/home/${USER}/.touchPadService
LOG_LOCATION=/home/${USER}/.touchPadService/log

test:; @echo "Hello" 

run@loop :; bash ./toggleTouchPad.sh

run@single :; bash ./toggleTouchPad.sh -s

install :; \
	bash serviceGenerator.sh && \
	mkdir -p ${SERVICE_LOCATION} && \
	mkdir -p ${SCRIPT_LOCATION} && \
	mkdir -p ${LOG_LOCATION} && \
	touch ${LOG_LOCATION}/${LOG_FILE_NAME} && \
	cp -u ${SCRIPT_FILE_NAME} ${SCRIPT_LOCATION}/${SCRIPT_FILE_NAME} && \
	cp -u ${SERVICE_FILE_NAME} ${SERVICE_LOCATION}/${SERVICE_FILE_NAME} && \
	systemctl --user enable ${SERVICE_FILE_NAME}  && \
	systemctl --user start ${SERVICE_FILE_NAME} && \
	systemctl --user daemon-reload

uninstall :; \
	systemctl --user stop ${SERVICE_FILE_NAME} && \
	systemctl --user disable ${SERVICE_FILE_NAME}  && \
	systemctl --user daemon-reload && \
	rm -r ${SCRIPT_LOCATION} && \
	# rm -r ${LOG_LOCATION} && \
	rm ${SERVICE_LOCATION}/${SERVICE_FILE_NAME}

reinstall :; \
	make uninstall && \
	make install && \
	systemctl status --user ${SERVICE_FILE_NAME}

findAll:; @echo "\n Script File: $(shell ls ${SCRIPT_LOCATION}/${SCRIPT_FILE_NAME}) \n" \
	"Log File: $(shell ls ${LOG_LOCATION}/${LOG_FILE_NAME}) \n" \
	"Service File: $(shell ls ${SERVICE_LOCATION}/${SERVICE_FILE_NAME}) \n" 

show@log :; tail ${LOG_LOCATION}/${LOG_FILE_NAME}

show@log+watch :; tail -f ${LOG_LOCATION}/${LOG_FILE_NAME}

show@log+all :; cat ${LOG_LOCATION}/${LOG_FILE_NAME}
